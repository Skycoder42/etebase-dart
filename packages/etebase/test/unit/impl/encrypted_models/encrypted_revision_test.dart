// ignore_for_file: prefer_asserts_with_message

import 'dart:convert';
import 'dart:typed_data';

import 'package:etebase/src/api/exceptions/crypto_failure.dart';
import 'package:etebase/src/api/exceptions/integrity_compromised.dart';
import 'package:etebase/src/api/exceptions/missing_content.dart';
import 'package:etebase/src/api/models/item_metadata.dart';
import 'package:etebase/src/impl/codec/message_pack_converter.dart';
import 'package:etebase/src/impl/crypto/collection_item_crypto_manager.dart';
import 'package:etebase/src/impl/crypto/crypto_mac.dart';
import 'package:etebase/src/impl/crypto/crypto_service.dart';
import 'package:etebase/src/impl/crypto/rollsum.dart';
import 'package:etebase/src/impl/encrypted_models/cached/cached_chunk.dart';
import 'package:etebase/src/impl/encrypted_models/cached/cached_revision.dart';
import 'package:etebase/src/impl/encrypted_models/chunk.dart';
import 'package:etebase/src/impl/encrypted_models/encrypted_revision.dart';
import 'package:etebase/src/impl/managers/client_impl.dart';
import 'package:meta/meta.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:msgpack_codec/msgpack_codec.dart';
import 'package:test/test.dart';

// ignore: directives_ordering
@GenerateNiceMocks([
  MockSpec<ClientImpl>(),
  MockSpec<CryptoService>(),
  MockSpec<MessagePackConverter>(),
  MockSpec<CollectionItemCryptoManager>(),
  MockSpec<CryptoMac>(),
  MockSpec<Rollsum>(),
])
import 'encrypted_revision_test.mocks.dart';

typedef TestNext = void Function(Uint8List data, int depth);

@immutable
class TestItemMetadata implements ItemMetadata {
  final ItemMetadata _self;
  final String extra;

  const TestItemMetadata(this._self, this.extra);

  TestItemMetadata.fromJson(Map<String, dynamic> json)
    : _self = ItemMetadata.fromJson(json),
      extra = json['extra'] as String;

  @override
  String? get color => _self.color;

  @override
  String? get description => _self.description;

  @override
  String? get itemType => _self.itemType;

  @override
  DateTime? get mtime => _self.mtime;

  @override
  String? get name => _self.name;

  @override
  Map<String, dynamic> toJson() => {..._self.toJson(), 'extra': extra};

  @override
  bool operator ==(Object other) =>
      other is TestItemMetadata && other._self == _self && other.extra == extra;

  @override
  int get hashCode => Object.hash(_self, extra);
}

void main() {
  group('$EncryptedRevision', () {
    const smartMockPrefix = 0x42;
    const smConverterEncode = 0x11;
    const smConverterEncodeRaw = 0x12;
    const smCryptoPad = 0x21;
    const smCryptoPadSmall = 0x22;
    const smCmCrypt = 0x31;
    const smCmDetachedCrypt = 0x32;
    const smCmDetachedMac = 0x33;
    const smCmMac = 0x34;
    const smMac = 0x41;
    const smMacUpdate = 0x42;
    const smMacUpdateLen = 0x43;

    final mockClient = MockClientImpl();
    final mockCryptoService = MockCryptoService();
    final mockMessagePackConverter = MockMessagePackConverter();
    final mockCryptoManager = MockCollectionItemCryptoManager();
    final mockCryptoMac = MockCryptoMac();
    final mockCryptoMacNoKey = MockCryptoMac();

    Uint8List wrap(int id, List<dynamic> data) => msgPack.encode([
      // header
      smartMockPrefix, id,
      // data
      ...data,
    ]);

    List<dynamic> unwrap(Uint8List raw, int id) {
      final decoded = msgPack.decode(raw);
      expect(decoded, isA<List<dynamic>>(), reason: 'decoded is List');
      final [int mPrefix, int mId, ...rest] = decoded as List;
      expect(mPrefix, smartMockPrefix, reason: 'has prefix');
      expect(mId, id, reason: 'has id');
      return rest;
    }

    void isWrappedImpl(
      Uint8List data,
      String name,
      int id,
      List<dynamic> expectations,
      int depth,
    ) {
      dynamic index = '-';
      try {
        final unwrapped = unwrap(data, id);
        expect(unwrapped, hasLength(expectations.length), reason: 'length');
        for (var i = 0; i < unwrapped.length; i++) {
          index = i;
          final value = unwrapped[i];
          final expectation = expectations[i];
          if (expectation is TestNext) {
            expect(value, isA<Uint8List>(), reason: 'is Uint8List');
            expectation(value as Uint8List, depth + 1);
          } else {
            expect(value, expectation);
          }
        }
      } catch (e) {
        fail('${'  ' * depth}> $name[$index]\n$e');
      }
    }

    TestNext isWrapped(String name, int id, List<dynamic> expectations) =>
        (data, depth) => isWrappedImpl(data, name, id, expectations, depth);

    void expectWrapped(Uint8List data, TestNext matcher) => matcher(data, 0);

    TestNext isAdHash(
      Uint8List testAd,
      Iterable<Chunk> chunks, {
      int deleted = 0,
    }) => isWrapped('cryptoMac(key)', smMac, [
      isTrue,
      isWrapped('notDeleted', smMacUpdate, [
        [deleted],
      ]),
      isWrapped('additionalData', smMacUpdateLen, [testAd]),
      isWrapped('chunksHash', smMacUpdate, [
        isWrapped('cryptoMac(noKey)', smMac, [
          isFalse,
          for (final (idx, chunk) in chunks.indexed)
            isWrapped('chunk[$idx].uid', smMacUpdate, [
              base64.decode(chunk.uid),
            ]),
        ]),
      ]),
    ]);

    void setupSmartMocks() {
      when(mockClient.converter).thenReturn(mockMessagePackConverter);

      when(mockMessagePackConverter.encode(any)).thenAnswer((i) {
        final [dynamic data] = i.positionalArguments;
        // ignore: avoid_dynamic_calls
        return wrap(smConverterEncode, [data.toJson()]);
      });
      when(mockMessagePackConverter.decode<ItemMetadata>(any)).thenAnswer((i) {
        final [Uint8List data] = i.positionalArguments;
        final [Map<dynamic, dynamic> json] = unwrap(data, smConverterEncode);
        return ItemMetadata.fromJson(json.cast());
      });
      when(mockMessagePackConverter.encodeRaw(any)).thenAnswer((i) {
        final [dynamic data] = i.positionalArguments;
        return wrap(smConverterEncodeRaw, [data]);
      });
      when(mockMessagePackConverter.decodeRaw(any)).thenAnswer((i) {
        final [Uint8List raw] = i.positionalArguments;
        final [dynamic data] = unwrap(raw, smConverterEncodeRaw);
        return data;
      });
      when(mockMessagePackConverter.base64Encode(any)).thenAnswer((i) {
        final [Uint8List data] = i.positionalArguments;
        return base64.encode(data);
      });
      when(mockMessagePackConverter.base64Decode(any)).thenAnswer((i) {
        final [String data] = i.positionalArguments;
        return base64.decode(data);
      });

      when(mockClient.crypto).thenReturn(mockCryptoService);

      when(mockCryptoService.bufferPadSmall(any)).thenAnswer((i) {
        final [Uint8List data] = i.positionalArguments;
        return wrap(smCryptoPadSmall, [data]);
      });
      when(mockCryptoService.bufferUnpadSmall(any)).thenAnswer((i) {
        final [Uint8List raw] = i.positionalArguments;
        final [Uint8List data] = unwrap(raw, smCryptoPadSmall);
        return data;
      });
      // ignore: discarded_futures
      when(mockCryptoService.bufferPad(any)).thenAnswer((i) {
        final [Uint8List data] = i.positionalArguments;
        return wrap(smCryptoPad, [data]);
      });
      // ignore: discarded_futures
      when(mockCryptoService.bufferUnpad(any)).thenAnswer((i) {
        final [Uint8List raw] = i.positionalArguments;
        final [Uint8List data] = unwrap(raw, smCryptoPad);
        return data;
      });
      when(mockCryptoService.shuffle<dynamic>(any)).thenAnswer((i) {
        final [List<dynamic> data] = i.positionalArguments;
        if (data.isEmpty) {
          return const [];
        }
        final tmp = data.first;
        data
          ..first = data.last
          ..last = tmp;

        final mapping = List.generate(data.length, (i) => i);
        return mapping
          ..first = mapping.length - 1
          ..last = 0;
      });

      // ignore: discarded_futures
      when(mockCryptoManager.encryptDetached(any, any)).thenAnswer((i) {
        final [Uint8List msg, Uint8List? ad] = i.positionalArguments;
        final cipher = wrap(smCmDetachedCrypt, [msg, ad]);
        final mac = wrap(smCmDetachedMac, [msg, ad]);
        return (mac: mac, nonceCipherText: cipher);
      });
      // ignore: discarded_futures
      when(mockCryptoManager.decryptDetached(any, any, any)).thenAnswer((i) {
        final [Uint8List cipher, Uint8List mac, Uint8List? ad] =
            i.positionalArguments;
        final [Uint8List msgC, Uint8List? adC] = unwrap(
          cipher,
          smCmDetachedCrypt,
        );
        final [Uint8List msgM, Uint8List? adM] = unwrap(mac, smCmDetachedMac);
        expect(adC, ad);
        expect(adM, ad);
        expect(msgM, msgC);
        return msgC;
      });
      // ignore: discarded_futures
      when(mockCryptoManager.verify(any, any, any)).thenAnswer((i) {
        final [Uint8List cipher, Uint8List mac, Uint8List? ad] =
            i.positionalArguments;
        final [Uint8List msgC, Uint8List? adC] = unwrap(
          cipher,
          smCmDetachedCrypt,
        );
        final [Uint8List msgM, Uint8List? adM] = unwrap(mac, smCmDetachedMac);
        expect(adC, ad);
        expect(adM, ad);
        expect(msgM, msgC);
      });
      when(
        // ignore: discarded_futures
        mockCryptoManager.calculateMac(any, withKey: anyNamed('withKey')),
      ).thenAnswer((i) {
        final [Uint8List message] = i.positionalArguments;
        final {#withKey: bool withKey} = i.namedArguments;
        return wrap(smCmMac, [message, withKey]);
      });
      // ignore: discarded_futures
      when(mockCryptoManager.encrypt(any, any)).thenAnswer((i) {
        final [Uint8List msg, Uint8List? ad] = i.positionalArguments;
        final cipher = wrap(smCmCrypt, [msg, ad]);
        return cipher;
      });
      // ignore: discarded_futures
      when(mockCryptoManager.decrypt(any, any)).thenAnswer((i) {
        final [Uint8List cipher, Uint8List? ad] = i.positionalArguments;
        final [Uint8List msgC, Uint8List? adC] = unwrap(cipher, smCmCrypt);
        expect(adC, ad);
        return msgC;
      });

      when(
        mockCryptoManager.getCryptoMac(withKey: anyNamed('withKey')),
      ).thenAnswer((i) {
        final {#withKey: bool withKey} = i.namedArguments;
        final values = <dynamic>[withKey];
        final cm = MockCryptoMac();
        when(cm.update(any)).thenAnswer((i) {
          final [Uint8List data] = i.positionalArguments;
          values.add(wrap(smMacUpdate, [data]));
        });
        when(cm.updateWithLenPrefix(any)).thenAnswer((i) {
          final [Uint8List data] = i.positionalArguments;
          values.add(wrap(smMacUpdateLen, [data]));
        });
        // ignore: discarded_futures
        when(cm.finalize()).thenAnswer((i) async => wrap(smMac, values));
        return cm;
      });
    }

    void setupRollsum(int blockSize) {
      when(mockCryptoManager.getChunker()).thenAnswer((i) {
        var ctr = 0;
        final chunker = MockRollsum();
        when(chunker.update(any)).thenAnswer((i) {
          ctr++;
        });
        when(chunker.split(any)).thenAnswer((i) {
          if (ctr >= blockSize) {
            ctr -= blockSize;
            return true;
          }
          return false;
        });
        return chunker;
      });
    }

    setUp(() {
      reset(mockClient);
      reset(mockCryptoService);
      reset(mockMessagePackConverter);
      reset(mockCryptoManager);
      reset(mockCryptoMac);
      reset(mockCryptoMacNoKey);

      provideDummy(const ItemMetadata());

      setupSmartMocks();

      setupRollsum(0xFFFFFFFF);
    });

    group('create', () {
      test('constructs new revision from meta and content', () async {
        final testAd = Uint8List.fromList([1, 2, 1]);
        const testMeta = ItemMetadata(name: 'test-meta');
        final testContent = Uint8List.fromList([7, 5, 4, 5]);

        final result = await EncryptedRevision.create(
          client: mockClient,
          cryptoManager: mockCryptoManager,
          additionalData: testAd,
          meta: testMeta,
          content: testContent,
        );

        final encryptedContents = [
          isWrapped('padded', smCryptoPadSmall, [
            isWrapped('encoded(meta)', smConverterEncode, [testMeta.toJson()]),
          ]),
          isAdHash(testAd, result.chunks),
        ];

        expectWrapped(
          base64.decode(result.uid),
          isWrapped('encrypted.mac', smCmDetachedMac, encryptedContents),
        );
        expectWrapped(
          result.meta,
          isWrapped('encrypted.cipher', smCmDetachedCrypt, encryptedContents),
        );
        expect(result.deleted, isFalse);
        expect(result.chunks, hasLength(1));
        expect(result.chunks.first.data, isNotNull);
        expectWrapped(
          base64.decode(result.chunks.first.uid),
          isWrapped('mac(content,key)', smCmMac, [testContent, isTrue]),
        );
        expectWrapped(
          result.chunks.first.data!,
          isWrapped('encrypted', smCmCrypt, [
            isWrapped('padded(content)', smCryptoPad, [testContent]),
            isNull,
          ]),
        );
      });

      test('constructs new revision from meta and empty content', () async {
        final testAd = Uint8List.fromList([4, 6, 5, 3, 4, 2]);
        const testMeta = ItemMetadata();
        final testContent = Uint8List(0);

        final result = await EncryptedRevision.create(
          client: mockClient,
          cryptoManager: mockCryptoManager,
          additionalData: testAd,
          meta: testMeta,
          content: testContent,
        );

        final encryptedContents = [
          isWrapped('padded', smCryptoPadSmall, [
            isWrapped('encoded(meta)', smConverterEncode, [testMeta.toJson()]),
          ]),
          isAdHash(testAd, []),
        ];

        expectWrapped(
          base64.decode(result.uid),
          isWrapped('encrypted.mac', smCmDetachedMac, encryptedContents),
        );
        expectWrapped(
          result.meta,
          isWrapped('encrypted.cipher', smCmDetachedCrypt, encryptedContents),
        );
        expect(result.deleted, isFalse);
        expect(result.chunks, isEmpty);
      });

      test('constructs new revision with multiple chunks', () async {
        const testBlockSize = 32768;
        final testAd = Uint8List.fromList([5, 6, 5, 3, 2, 4, 2, 3]);
        const testMeta = ItemMetadata();
        final testContent = Uint8List.fromList(
          List.generate(16384 * 5, (i) => i % 100),
        );

        setupRollsum(testBlockSize);

        final result = await EncryptedRevision.create(
          client: mockClient,
          cryptoManager: mockCryptoManager,
          additionalData: testAd,
          meta: testMeta,
          content: testContent,
        );

        expect(result.deleted, isFalse);
        expect(result.chunks, hasLength(4));
        // swap last and first data chunk, because of the shuffle
        // the final chunk contains data about the shuffle, so leave it
        final [c3, c2, c1, c4] = result.chunks;

        // chunk 1
        expect(c1.data, isNotNull);
        expectWrapped(
          base64.decode(c1.uid),
          isWrapped('mac(content,key)', smCmMac, [
            testContent.sublist(0, testBlockSize),
            isTrue,
          ]),
        );
        expectWrapped(
          c1.data!,
          isWrapped('encrypted', smCmCrypt, [
            isWrapped('padded(content)', smCryptoPad, [
              testContent.sublist(0, testBlockSize),
            ]),
            isNull,
          ]),
        );
        // chunk 2
        expect(c2.data, isNotNull);
        expectWrapped(
          base64.decode(c2.uid),
          isWrapped('mac(content,key)', smCmMac, [
            testContent.sublist(testBlockSize, 2 * testBlockSize),
            isTrue,
          ]),
        );
        expectWrapped(
          c2.data!,
          isWrapped('encrypted', smCmCrypt, [
            isWrapped('padded(content)', smCryptoPad, [
              testContent.sublist(testBlockSize, 2 * testBlockSize),
            ]),
            isNull,
          ]),
        );
        // chunk 3
        expect(c3.data, isNotNull);
        expectWrapped(
          base64.decode(c3.uid),
          isWrapped('mac(content,key)', smCmMac, [
            testContent.sublist(2 * testBlockSize),
            isTrue,
          ]),
        );
        expectWrapped(
          c3.data!,
          isWrapped('encrypted', smCmCrypt, [
            isWrapped('padded(content)', smCryptoPad, [
              testContent.sublist(2 * testBlockSize),
            ]),
            isNull,
          ]),
        );
        // c4 - shuffle data
        expect(c4.data, isNotNull);
        expectWrapped(
          base64.decode(c4.uid),
          isWrapped('mac(content,key)', smCmMac, [
            isWrapped('indices', smConverterEncodeRaw, [
              [
                // first and last swapped
                [2, 1, 0],
              ],
            ]),
            isTrue,
          ]),
        );
        expectWrapped(
          c4.data!,
          isWrapped('encrypted', smCmCrypt, [
            isWrapped('padded', smCryptoPad, [
              isWrapped('indices', smConverterEncodeRaw, [
                [
                  // first and last swapped
                  [2, 1, 0],
                ],
              ]),
            ]),
            isNull,
          ]),
        );

        // id and metadata
        final encryptedContents = [
          isWrapped('padded', smCryptoPadSmall, [
            isWrapped('encoded(meta)', smConverterEncode, [testMeta.toJson()]),
          ]),
          isAdHash(testAd, result.chunks),
        ];

        expectWrapped(
          base64.decode(result.uid),
          isWrapped('encrypted.mac', smCmDetachedMac, encryptedContents),
        );
        expectWrapped(
          result.meta,
          isWrapped('encrypted.cipher', smCmDetachedCrypt, encryptedContents),
        );
      });

      test('constructs new revision with deduplicated chunks', () async {
        const testBlockSize = 16384;
        final testAd = Uint8List.fromList([5, 6, 5, 3, 2, 4, 2, 3]);
        const testMeta = ItemMetadata();
        final testContent = Uint8List.fromList([
          ...List.filled(testBlockSize * 3, 0x11),
          ...List.filled(testBlockSize * 1, 0x12),
          ...List.filled(testBlockSize * 2, 0x11),
          ...List.filled(testBlockSize * 2, 0x12),
        ]);

        setupRollsum(testBlockSize);

        final result = await EncryptedRevision.create(
          client: mockClient,
          cryptoManager: mockCryptoManager,
          additionalData: testAd,
          meta: testMeta,
          content: testContent,
        );

        expect(result.deleted, isFalse);
        expect(result.chunks, hasLength(3));
        final [c1, c2, c3] = result.chunks;

        // chunk 1 - which is index 1 - aka 0x12
        expect(c1.data, isNotNull);
        expectWrapped(
          base64.decode(c1.uid),
          isWrapped('mac(content,key)', smCmMac, [
            Uint8List.fromList(List.filled(testBlockSize * 1, 0x12)),
            isTrue,
          ]),
        );
        expectWrapped(
          c1.data!,
          isWrapped('encrypted', smCmCrypt, [
            isWrapped('padded(content)', smCryptoPad, [
              Uint8List.fromList(List.filled(testBlockSize * 1, 0x12)),
            ]),
            isNull,
          ]),
        );
        // chunk 2 - which is index 0 - aka 0x11
        expect(c2.data, isNotNull);
        expectWrapped(
          base64.decode(c2.uid),
          isWrapped('mac(content,key)', smCmMac, [
            Uint8List.fromList(List.filled(testBlockSize * 1, 0x11)),
            isTrue,
          ]),
        );
        expectWrapped(
          c2.data!,
          isWrapped('encrypted', smCmCrypt, [
            isWrapped('padded(content)', smCryptoPad, [
              Uint8List.fromList(List.filled(testBlockSize * 1, 0x11)),
            ]),
            isNull,
          ]),
        );
        // chunk 3 - index list with actual indices
        expect(c3.data, isNotNull);
        expectWrapped(
          base64.decode(c3.uid),
          isWrapped('mac(content,key)', smCmMac, [
            isWrapped('indices', smConverterEncodeRaw, [
              [
                [1, 1, 1, 0, 1, 1, 0, 0],
              ],
            ]),
            isTrue,
          ]),
        );
        expectWrapped(
          c3.data!,
          isWrapped('encrypted', smCmCrypt, [
            isWrapped('padded', smCryptoPad, [
              isWrapped('indices', smConverterEncodeRaw, [
                [
                  [1, 1, 1, 0, 1, 1, 0, 0],
                ],
              ]),
            ]),
            isNull,
          ]),
        );

        // id and metadata
        final encryptedContents = [
          isWrapped('padded', smCryptoPadSmall, [
            isWrapped('encoded(meta)', smConverterEncode, [testMeta.toJson()]),
          ]),
          isAdHash(testAd, result.chunks),
        ];

        expectWrapped(
          base64.decode(result.uid),
          isWrapped('encrypted.mac', smCmDetachedMac, encryptedContents),
        );
        expectWrapped(
          result.meta,
          isWrapped('encrypted.cipher', smCmDetachedCrypt, encryptedContents),
        );
      });

      test('honor maximum chunk size', () async {
        const testBlockSize = 70000;
        final testAd = Uint8List.fromList([5, 6, 5, 3, 2, 4, 2, 3]);
        const testMeta = ItemMetadata();
        final testContent = Uint8List.fromList(
          List.generate(testBlockSize, (i) => i % 256),
        );

        setupRollsum(testBlockSize);

        final result = await EncryptedRevision.create(
          client: mockClient,
          cryptoManager: mockCryptoManager,
          additionalData: testAd,
          meta: testMeta,
          content: testContent,
        );

        expect(result.deleted, isFalse);
        expect(result.chunks, hasLength(3));
        final [c1, c2, _] = result.chunks;

        // chunk 1 - remaining data
        expect(c1.data, isNotNull);
        expectWrapped(
          base64.decode(c1.uid),
          isWrapped('mac(content,key)', smCmMac, [
            hasLength(testBlockSize - (1 << 16)),
            isTrue,
          ]),
        );
        expectWrapped(
          c1.data!,
          isWrapped('encrypted', smCmCrypt, [
            isWrapped('padded(content)', smCryptoPad, [
              hasLength(testBlockSize - (1 << 16)),
            ]),
            isNull,
          ]),
        );
        // chunk 2 - which is index 0 - aka 0x11
        expect(c2.data, isNotNull);
        expectWrapped(
          base64.decode(c2.uid),
          isWrapped('mac(content,key)', smCmMac, [hasLength(1 << 16), isTrue]),
        );
        expectWrapped(
          c2.data!,
          isWrapped('encrypted', smCmCrypt, [
            isWrapped('padded(content)', smCryptoPad, [hasLength(1 << 16)]),
            isNull,
          ]),
        );
      });

      test('honor minimum chunk size', () async {
        final testAd = Uint8List.fromList([5, 6, 5, 3, 2, 4, 2, 3]);
        const testMeta = ItemMetadata();
        final testContent = Uint8List.fromList(
          List.generate(20000, (i) => i % 256),
        );

        setupRollsum(10);

        final result = await EncryptedRevision.create(
          client: mockClient,
          cryptoManager: mockCryptoManager,
          additionalData: testAd,
          meta: testMeta,
          content: testContent,
        );

        expect(result.deleted, isFalse);
        expect(result.chunks, hasLength(3));
        final [c1, c2, _] = result.chunks;

        // chunk 1 - remaining data
        expect(c1.data, isNotNull);
        expectWrapped(
          base64.decode(c1.uid),
          isWrapped('mac(content,key)', smCmMac, [
            hasLength(20000 - (1 << 14)),
            isTrue,
          ]),
        );
        expectWrapped(
          c1.data!,
          isWrapped('encrypted', smCmCrypt, [
            isWrapped('padded(content)', smCryptoPad, [
              hasLength(20000 - (1 << 14)),
            ]),
            isNull,
          ]),
        );
        // chunk 2 - which is index 0 - aka 0x11
        expect(c2.data, isNotNull);
        expectWrapped(
          base64.decode(c2.uid),
          isWrapped('mac(content,key)', smCmMac, [hasLength(1 << 14), isTrue]),
        );
        expectWrapped(
          c2.data!,
          isWrapped('encrypted', smCmCrypt, [
            isWrapped('padded(content)', smCryptoPad, [hasLength(1 << 14)]),
            isNull,
          ]),
        );
      });
    });

    test('fromJson/toJson de/serializes data correctly', () {
      const testUid = 'test-uid';
      final testMeta = Uint8List.fromList([1]);
      final testChunk1 = Chunk('chunk-1', Uint8List.fromList([2]));
      const testChunk2 = Chunk('chunk-2', null);
      final testJsonData = {
        'uid': testUid,
        'meta': testMeta,
        'chunks': [testChunk1.toJson(), testChunk2.toJson()],
        'deleted': true,
      };

      final revision = EncryptedRevision.fromJson(testJsonData);

      expect(revision.uid, testUid);
      expect(revision.meta, testMeta);
      expect(revision.chunks, [testChunk1, testChunk2]);
      expect(revision.deleted, isTrue);

      final json = revision.toJson();

      expect(json, testJsonData);
    });

    test('cacheLoad/cacheSave restores/saves revision correctly', () {
      final testUid = base64.encode([1, 2, 3]);
      final testMeta = Uint8List.fromList([1]);
      final testChunk1 = Chunk(base64.encode([10, 1]), Uint8List.fromList([2]));
      final testChunk2 = Chunk(base64.encode([10, 2]), null);
      final testCached = CachedRevision(
        uid: Uint8List.fromList([1, 2, 3]),
        meta: testMeta,
        deleted: true,
        chunks: [
          CachedChunk(Uint8List.fromList([10, 1]), Uint8List.fromList([2])),
          CachedChunk(Uint8List.fromList([10, 2])),
        ],
      );
      final testWrappedCached = wrap(184, testCached.toJson());

      provideDummy(testCached);
      when(
        mockMessagePackConverter.decode<CachedRevision>(any),
      ).thenReturn(testCached);
      when(mockMessagePackConverter.encode(any)).thenReturn(testWrappedCached);

      final revision = EncryptedRevision.cacheLoad(
        mockClient,
        testWrappedCached,
      );

      expect(revision.uid, testUid);
      expect(revision.meta, testMeta);
      expect(revision.chunks, [testChunk1, testChunk2]);
      expect(revision.deleted, isTrue);

      verify(
        mockMessagePackConverter.decode<CachedRevision>(testWrappedCached),
      );
      clearInteractions(mockMessagePackConverter);

      // with content
      final cachedWithContent = revision.cacheSave(
        mockClient,
        saveContent: true,
      );

      expect(cachedWithContent, testWrappedCached);

      verify(mockMessagePackConverter.encode(testCached));
      clearInteractions(mockMessagePackConverter);

      // without content
      final cachedWithoutContent = revision.cacheSave(
        mockClient,
        saveContent: false,
      );

      expect(cachedWithoutContent, testWrappedCached);

      verify(
        mockMessagePackConverter.encode(
          CachedRevision(
            uid: testCached.uid,
            meta: testCached.meta,
            deleted: testCached.deleted,
            chunks: [
              CachedChunk(testCached.chunks[0].uid),
              CachedChunk(testCached.chunks[1].uid),
            ],
          ),
        ),
      );
      clearInteractions(mockMessagePackConverter);
    });

    group('verify', () {
      test('validates integrity of metadata', () async {
        final testAd = Uint8List.fromList([4, 5, 4, 23, 1, 2]);
        const testMeta = ItemMetadata(
          name: 'test-meta',
          description: 'test-description',
        );
        final testContent = Uint8List.fromList([5, 4, 2, 21, 1]);

        final sut = await EncryptedRevision.create(
          client: mockClient,
          cryptoManager: mockCryptoManager,
          additionalData: testAd,
          meta: testMeta,
          content: testContent,
        );

        await sut.verify(mockClient, mockCryptoManager, testAd);

        final [Uint8List captured] = verify(
          mockCryptoManager.verify(
            sut.meta,
            base64.decode(sut.uid),
            captureAny,
          ),
        ).captured;

        expectWrapped(captured, isAdHash(testAd, sut.chunks));
      });

      test(
        'translates crypto failure to integrity compromised exception',
        () async {
          final testAd = Uint8List.fromList([4, 5, 4, 23, 1, 2]);
          const testMeta = ItemMetadata(
            name: 'test-meta',
            description: 'test-description',
          );
          final testContent = Uint8List.fromList([5, 4, 2, 21, 1]);

          final sut = await EncryptedRevision.create(
            client: mockClient,
            cryptoManager: mockCryptoManager,
            additionalData: testAd,
            meta: testMeta,
            content: testContent,
          );

          when(
            mockCryptoManager.verify(any, any, any),
          ).thenThrow(CryptoFailure());

          await expectLater(
            sut.verify(mockClient, mockCryptoManager, testAd),
            throwsA(isA<IntegrityCompromised>()),
          );
        },
      );
    });

    group('setMeta', () {
      test('updates existing metadata', () async {
        final testAd = Uint8List.fromList([6, 5, 2, 3, 11]);
        const testMeta = ItemMetadata(
          name: 'test-meta',
          description: 'test-description',
        );
        final testChunks = [
          Chunk(base64.encode([3, 2, 3]), null),
        ];

        final sut = EncryptedRevision()
          ..uid = 'default'
          ..meta = Uint8List(0)
          ..chunks = testChunks;

        await sut.setMeta(mockClient, mockCryptoManager, testAd, testMeta);

        final encryptedContents = [
          isWrapped('padded', smCryptoPadSmall, [
            isWrapped('encoded(meta)', smConverterEncode, [testMeta.toJson()]),
          ]),
          isAdHash(testAd, testChunks),
        ];

        expectWrapped(
          base64.decode(sut.uid),
          isWrapped('encrypted.mac', smCmDetachedMac, encryptedContents),
        );
        expectWrapped(
          sut.meta,
          isWrapped('encrypted.cipher', smCmDetachedCrypt, encryptedContents),
        );
      });

      test('can persist non default metadata', () async {
        final testAd = Uint8List.fromList([6, 5, 2, 3, 11]);
        const testMeta = TestItemMetadata(
          ItemMetadata(name: 'test-meta', description: 'test-description'),
          'test-extra',
        );
        final testChunks = [
          Chunk(base64.encode([3, 2, 3]), null),
        ];

        final sut = EncryptedRevision()
          ..uid = 'default'
          ..meta = Uint8List(0)
          ..chunks = testChunks;

        await sut.setMeta(mockClient, mockCryptoManager, testAd, testMeta);

        final encryptedContents = [
          isWrapped('padded', smCryptoPadSmall, [
            isWrapped('encoded(meta)', smConverterEncode, [testMeta.toJson()]),
          ]),
          isAdHash(testAd, testChunks),
        ];

        expectWrapped(
          base64.decode(sut.uid),
          isWrapped('encrypted.mac', smCmDetachedMac, encryptedContents),
        );
        expectWrapped(
          sut.meta,
          isWrapped('encrypted.cipher', smCmDetachedCrypt, encryptedContents),
        );
      });
    });

    group('getMeta', () {
      test('restores original metadata', () async {
        final testAd = Uint8List.fromList([5, 4, 2, 3, 1, 2]);
        const testMeta = ItemMetadata(name: 'test-meta', color: '#AABBCC');
        final testContent = Uint8List.fromList([5, 6, 5, 2, 1, 2, 1]);

        final sut = await EncryptedRevision.create(
          client: mockClient,
          cryptoManager: mockCryptoManager,
          additionalData: testAd,
          meta: testMeta,
          content: testContent,
        );

        final meta = await sut.getMeta(mockClient, mockCryptoManager, testAd);
        expect(meta, testMeta);
      });

      test('restores custom metadata', () async {
        final testAd = Uint8List.fromList([5, 4, 2, 3, 1, 2]);
        const testMeta = TestItemMetadata(
          ItemMetadata(name: 'test-meta', color: '#AABBCC'),
          'test-extra',
        );
        final testContent = Uint8List.fromList([5, 6, 5, 2, 1, 2, 1]);

        provideDummy(testMeta);
        when(
          mockMessagePackConverter.decode<TestItemMetadata>(any),
        ).thenAnswer((i) {
          final [Uint8List data] = i.positionalArguments;
          final [Map<dynamic, dynamic> json] = unwrap(data, smConverterEncode);
          return TestItemMetadata.fromJson(json.cast());
        });

        final sut = await EncryptedRevision.create(
          client: mockClient,
          cryptoManager: mockCryptoManager,
          additionalData: testAd,
          meta: testMeta,
          content: testContent,
        );

        final meta = await sut.getMeta<TestItemMetadata>(
          mockClient,
          mockCryptoManager,
          testAd,
        );
        expect(meta, testMeta);
      });
    });

    group('setContent', () {
      // as create calls setContent internally, all other variants do not need
      // to be tested here explicitly again. This one test case is required,
      // as the setContent loads the existing metadata and updates it instead
      // of filling it in from the construction.
      test('updates revision content', () async {
        final testAd = Uint8List.fromList([5, 4, 3, 1, 5, 3]);
        const testMeta = ItemMetadata(name: 'test-meta');
        final testContent = Uint8List.fromList([5, 6, 2, 1, 4, 4, 1]);

        final sut = await EncryptedRevision.create(
          client: mockClient,
          cryptoManager: mockCryptoManager,
          additionalData: testAd,
          meta: testMeta,
          content: Uint8List(0),
        );

        final oldEncryptedContent = [
          isWrapped('padded', smCryptoPadSmall, [
            isWrapped('encoded(meta)', smConverterEncode, [testMeta.toJson()]),
          ]),
          isAdHash(testAd, []),
        ];
        expectWrapped(
          base64.decode(sut.uid),
          isWrapped('encrypted.mac', smCmDetachedMac, oldEncryptedContent),
        );
        expectWrapped(
          sut.meta,
          isWrapped('encrypted.cipher', smCmDetachedCrypt, oldEncryptedContent),
        );

        final oldUid = sut.uid;
        final oldMeta = sut.meta;

        await sut.setContent(
          mockClient,
          mockCryptoManager,
          additionalData: testAd,
          content: testContent,
        );

        expect(sut.uid, isNot(oldUid));
        expect(sut.meta, isNot(oldMeta));

        final encryptedContents = [
          isWrapped('padded', smCryptoPadSmall, [
            isWrapped('encoded(meta)', smConverterEncode, [testMeta.toJson()]),
          ]),
          isAdHash(testAd, sut.chunks),
        ];

        expectWrapped(
          base64.decode(sut.uid),
          isWrapped('encrypted.mac', smCmDetachedMac, encryptedContents),
        );
        expectWrapped(
          sut.meta,
          isWrapped('encrypted.cipher', smCmDetachedCrypt, encryptedContents),
        );
        expect(sut.deleted, isFalse);
        expect(sut.chunks, hasLength(1));
        expect(sut.chunks.first.data, isNotNull);
        expectWrapped(
          base64.decode(sut.chunks.first.uid),
          isWrapped('mac(content,key)', smCmMac, [testContent, isTrue]),
        );
        expectWrapped(
          sut.chunks.first.data!,
          isWrapped('encrypted', smCmCrypt, [
            isWrapped('padded(content)', smCryptoPad, [testContent]),
            isNull,
          ]),
        );
      });

      test('can set content from stream', () async {
        final testAd = Uint8List.fromList([5, 4, 3, 1, 5, 3]);
        const testMeta = ItemMetadata(name: 'test-meta');
        final testContent = Stream.fromIterable([
          [5, 6],
          [2],
          [1, 4, 4, 1],
        ]);
        final testCombinedContent = await testContent.expand((e) => e).toList();

        final sut = await EncryptedRevision.create(
          client: mockClient,
          cryptoManager: mockCryptoManager,
          additionalData: testAd,
          meta: testMeta,
          content: Uint8List(0),
        );

        final oldEncryptedContent = [
          isWrapped('padded', smCryptoPadSmall, [
            isWrapped('encoded(meta)', smConverterEncode, [testMeta.toJson()]),
          ]),
          isAdHash(testAd, []),
        ];
        expectWrapped(
          base64.decode(sut.uid),
          isWrapped('encrypted.mac', smCmDetachedMac, oldEncryptedContent),
        );
        expectWrapped(
          sut.meta,
          isWrapped('encrypted.cipher', smCmDetachedCrypt, oldEncryptedContent),
        );

        final oldUid = sut.uid;
        final oldMeta = sut.meta;

        await sut.setContentStream(
          mockClient,
          mockCryptoManager,
          additionalData: testAd,
          content: testContent,
        );

        expect(sut.uid, isNot(oldUid));
        expect(sut.meta, isNot(oldMeta));

        final encryptedContents = [
          isWrapped('padded', smCryptoPadSmall, [
            isWrapped('encoded(meta)', smConverterEncode, [testMeta.toJson()]),
          ]),
          isAdHash(testAd, sut.chunks),
        ];

        expectWrapped(
          base64.decode(sut.uid),
          isWrapped('encrypted.mac', smCmDetachedMac, encryptedContents),
        );
        expectWrapped(
          sut.meta,
          isWrapped('encrypted.cipher', smCmDetachedCrypt, encryptedContents),
        );
        expect(sut.deleted, isFalse);
        expect(sut.chunks, hasLength(1));
        expect(sut.chunks.first.data, isNotNull);
        expectWrapped(
          base64.decode(sut.chunks.first.uid),
          isWrapped('mac(content,key)', smCmMac, [testCombinedContent, isTrue]),
        );
        expectWrapped(
          sut.chunks.first.data!,
          isWrapped('encrypted', smCmCrypt, [
            isWrapped('padded(content)', smCryptoPad, [testCombinedContent]),
            isNull,
          ]),
        );
      });
    });

    group('getContent', () {
      test('restores original content data', () async {
        final testAd = Uint8List.fromList([9, 7, 22, 4, 2]);
        const testMeta = ItemMetadata(name: 'test-meta');
        final testContent = Uint8List.fromList([34, 1, 4, 12]);

        final sut = await EncryptedRevision.create(
          client: mockClient,
          cryptoManager: mockCryptoManager,
          additionalData: testAd,
          meta: testMeta,
          content: testContent,
        );

        expect(sut.chunks, hasLength(1));

        final content = await sut.getContent(mockClient, mockCryptoManager);
        expect(content, testContent);
      });

      test('restores empty content', () async {
        final testAd = Uint8List.fromList([9, 7, 22, 4, 2]);
        const testMeta = ItemMetadata(name: 'test-meta');
        final testContent = Uint8List(0);

        final sut = await EncryptedRevision.create(
          client: mockClient,
          cryptoManager: mockCryptoManager,
          additionalData: testAd,
          meta: testMeta,
          content: testContent,
        );

        expect(sut.chunks, isEmpty);

        final content = await sut.getContent(mockClient, mockCryptoManager);
        expect(content, isEmpty);
      });

      test('restores data that was split in multiple chunks', () async {
        const testBlockSize = 32768;
        final testAd = Uint8List.fromList([5, 6, 5, 3, 44, 2, 3]);
        const testMeta = ItemMetadata();
        final testContent = Uint8List.fromList(
          List.generate(16384 * 5, (i) => i % 100),
        );

        setupRollsum(testBlockSize);

        final sut = await EncryptedRevision.create(
          client: mockClient,
          cryptoManager: mockCryptoManager,
          additionalData: testAd,
          meta: testMeta,
          content: testContent,
        );

        expect(sut.chunks, hasLength(4));

        final content = await sut.getContent(mockClient, mockCryptoManager);
        expect(content, testContent);
      });

      test('restores data from deduplicated chunks', () async {
        const testBlockSize = 16384;
        final testAd = Uint8List.fromList([6, 5, 2, 2, 41, 2]);
        const testMeta = ItemMetadata();
        final testContent = Uint8List.fromList([
          ...List.filled(testBlockSize * 3, 0x11),
          ...List.filled(testBlockSize * 1, 0x12),
          ...List.filled(testBlockSize * 2, 0x11),
          ...List.filled(testBlockSize * 2, 0x12),
        ]);

        setupRollsum(testBlockSize);

        final sut = await EncryptedRevision.create(
          client: mockClient,
          cryptoManager: mockCryptoManager,
          additionalData: testAd,
          meta: testMeta,
          content: testContent,
        );

        expect(sut.chunks, hasLength(3));

        final content = await sut.getContent(mockClient, mockCryptoManager);
        expect(content, testContent);
      });

      test(
        'throws MissingContent if at least one chunk is missing data',
        () async {
          const testBlockSize = 32768;
          final testAd = Uint8List.fromList([5, 6, 5, 3, 44, 2, 3]);
          const testMeta = ItemMetadata();
          final testContent = Uint8List.fromList(
            List.generate(16384 * 5, (i) => i % 100),
          );

          setupRollsum(testBlockSize);

          final sut = await EncryptedRevision.create(
            client: mockClient,
            cryptoManager: mockCryptoManager,
            additionalData: testAd,
            meta: testMeta,
            content: testContent,
          );

          expect(sut.chunks, hasLength(4));
          sut.chunks = [
            sut.chunks[0],
            sut.chunks[1],
            sut.chunks[2].copyWith(data: null),
            sut.chunks[3],
          ];

          expect(
            () => sut.getContent(mockClient, mockCryptoManager),
            throwsA(isA<MissingContent>()),
          );
        },
      );

      test(
        'throws IntegrityCompromised if plain data hash does not match uid',
        () async {
          final testAd = Uint8List.fromList([5, 4, 2, 5, 1]);
          const testMeta = ItemMetadata(name: 'test-meta');
          final testContent = Uint8List.fromList([34, 1, 4, 12]);

          final sut = await EncryptedRevision.create(
            client: mockClient,
            cryptoManager: mockCryptoManager,
            additionalData: testAd,
            meta: testMeta,
            content: Uint8List.fromList([5, 4, 1, 2]),
          );

          final oldChunk = sut.chunks.single;

          await sut.setContent(
            mockClient,
            mockCryptoManager,
            additionalData: testAd,
            content: testContent,
          );

          // replace chunk id
          sut.chunks = [sut.chunks.single.copyWith(uid: oldChunk.uid)];

          // try to get content
          expect(
            () => sut.getContent(mockClient, mockCryptoManager),
            throwsA(
              isA<IntegrityCompromised>().having(
                (m) => m.message,
                'message',
                contains(oldChunk.uid),
              ),
            ),
          );
        },
      );

      test('returns chunked data as stream', () async {
        const testBlockSize = 32768;
        final testAd = Uint8List.fromList([5, 6, 5, 3, 44, 2, 3]);
        const testMeta = ItemMetadata();
        final testContent = Uint8List.fromList(
          List.generate(16384 * 5, (i) => i % 100),
        );

        setupRollsum(testBlockSize);

        final sut = await EncryptedRevision.create(
          client: mockClient,
          cryptoManager: mockCryptoManager,
          additionalData: testAd,
          meta: testMeta,
          content: testContent,
        );

        expect(sut.chunks, hasLength(4));

        final content = sut.getContentStream(mockClient, mockCryptoManager);
        expect(
          content,
          emitsInOrder([
            testContent.sublist(0, testBlockSize),
            testContent.sublist(testBlockSize, testBlockSize * 2),
            testContent.sublist(testBlockSize * 2),
            emitsDone,
          ]),
        );
      });
    });

    group('delete', () {
      test(
        'sets deleted to true and updates metadata if data should be kept',
        () async {
          final testAd = Uint8List.fromList([6, 4, 1, 2, 4, 1]);
          const testMeta = ItemMetadata(name: 'test-meta');
          final testContent = Uint8List.fromList([11, 34, 23]);

          final sut = await EncryptedRevision.create(
            client: mockClient,
            cryptoManager: mockCryptoManager,
            additionalData: testAd,
            meta: testMeta,
            content: testContent,
          );

          await sut.delete(
            mockClient,
            mockCryptoManager,
            testAd,
            preserveContent: true,
          );

          expect(sut.deleted, isTrue);
          expect(sut.chunks, hasLength(1));

          final encryptedContents = [
            isWrapped('padded', smCryptoPadSmall, [
              isWrapped('encoded(meta)', smConverterEncode, [
                testMeta.toJson(),
              ]),
            ]),
            isAdHash(testAd, sut.chunks, deleted: 1),
          ];
          expectWrapped(
            base64.decode(sut.uid),
            isWrapped('encrypted.mac', smCmDetachedMac, encryptedContents),
          );
          expectWrapped(
            sut.meta,
            isWrapped('encrypted.cipher', smCmDetachedCrypt, encryptedContents),
          );
        },
      );

      test('sets deleted to true, updates metadata and clears chunks '
          'if data should not be kept', () async {
        final testAd = Uint8List.fromList([6, 4, 1, 2, 4, 1]);
        const testMeta = ItemMetadata(name: 'test-meta');
        final testContent = Uint8List.fromList([11, 34, 23]);

        final sut = await EncryptedRevision.create(
          client: mockClient,
          cryptoManager: mockCryptoManager,
          additionalData: testAd,
          meta: testMeta,
          content: testContent,
        );

        await sut.delete(
          mockClient,
          mockCryptoManager,
          testAd,
          preserveContent: false,
        );

        expect(sut.deleted, isTrue);
        expect(sut.chunks, isEmpty);

        final encryptedContents = [
          isWrapped('padded', smCryptoPadSmall, [
            isWrapped('encoded(meta)', smConverterEncode, [testMeta.toJson()]),
          ]),
          isAdHash(testAd, [], deleted: 1),
        ];
        expectWrapped(
          base64.decode(sut.uid),
          isWrapped('encrypted.mac', smCmDetachedMac, encryptedContents),
        );
        expectWrapped(
          sut.meta,
          isWrapped('encrypted.cipher', smCmDetachedCrypt, encryptedContents),
        );
      });
    });

    test('clone creates new revision with identical data', () {
      final sut = EncryptedRevision()
        ..uid = 'default'
        ..meta = Uint8List(0)
        ..deleted = true
        ..chunks = [
          Chunk('chunk-1', Uint8List.fromList([33, 1])),
          const Chunk('chunk-2', null),
        ];

      final result = sut.clone();

      expect(result.uid, sut.uid);
      expect(result.meta, sut.meta);
      expect(result.deleted, sut.deleted);
      expect(result.chunks, sut.chunks);
      expect(result.chunks, isNot(same(sut.chunks)));
    });
  });
}
