// ignore_for_file: prefer_asserts_with_message

import 'dart:convert';
import 'dart:typed_data';

import 'package:etebase/src/api/models/etebase_item_metadata.dart';
import 'package:etebase/src/impl/codec/message_pack_converter.dart';
import 'package:etebase/src/impl/crypto/collection_item_crypto_manager.dart';
import 'package:etebase/src/impl/crypto/crypto_mac.dart';
import 'package:etebase/src/impl/crypto/crypto_service.dart';
import 'package:etebase/src/impl/crypto/rollsum.dart';
import 'package:etebase/src/impl/encrypted_models/encrypted_revision.dart';
import 'package:etebase/src/impl/managers/client.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:msgpack_codec/msgpack_codec.dart';
import 'package:test/test.dart';

// ignore: directives_ordering
@GenerateNiceMocks([
  MockSpec<Client>(),
  MockSpec<CryptoService>(),
  MockSpec<MessagePackConverter>(),
  MockSpec<CollectionItemCryptoManager>(),
  MockSpec<CryptoMac>(),
  MockSpec<Rollsum>(),
])
import 'encrypted_revision_test.mocks.dart';

typedef TestNext = void Function(Uint8List data, int depth);

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

    final mockClient = MockClient();
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
      expect(decoded, isA<List<dynamic>>());
      final [int mPrefix, int mId, ...rest] = decoded as List;
      expect(mPrefix, smartMockPrefix);
      expect(mId, id);
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
        expect(unwrapped, hasLength(expectations.length));
        for (var i = 0; i < unwrapped.length; i++) {
          index = i;
          final value = unwrapped[i];
          final expectation = expectations[i];
          if (expectation is TestNext) {
            expect(value, isA<Uint8List>());
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

    void setupSmartMocks() {
      when(mockClient.converter).thenReturn(mockMessagePackConverter);

      when(mockMessagePackConverter.encode(any)).thenAnswer((i) {
        final [dynamic data] = i.positionalArguments;
        // ignore: avoid_dynamic_calls
        return wrap(smConverterEncode, [data.toJson()]);
      });
      when(mockMessagePackConverter.decode<EtebaseItemMetadata>(any))
          .thenAnswer((i) {
        final [Uint8List data] = i.positionalArguments;
        final [Map<dynamic, dynamic> json] = unwrap(data, smConverterEncode);
        return EtebaseItemMetadata.fromJson(json.cast());
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
        final [Uint8List msgC, Uint8List? adC] =
            unwrap(cipher, smCmDetachedCrypt);
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
        final [Uint8List msgC, Uint8List? adC] =
            unwrap(cipher, smCmDetachedCrypt);
        final [Uint8List msgM, Uint8List? adM] = unwrap(mac, smCmDetachedMac);
        expect(adC, ad);
        expect(adM, ad);
        expect(msgM, msgC);
        return true;
      });
      // ignore: discarded_futures
      when(mockCryptoManager.calculateMac(any, withKey: anyNamed('withKey')))
          .thenAnswer((i) {
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

      when(mockCryptoManager.getCryptoMac(withKey: anyNamed('withKey')))
          .thenAnswer((i) {
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

      when(mockCryptoManager.getChunker()).thenAnswer((i) {
        var ctr = 0;
        final chunker = MockRollsum();
        when(chunker.update(any)).thenAnswer((i) {
          final [int ch] = i.positionalArguments;
          ctr += ch;
        });
        when(chunker.split(any)).thenAnswer((i) {
          final [int mask] = i.positionalArguments;
          if (ctr > mask) {
            ctr -= mask;
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

      provideDummy(const EtebaseItemMetadata());

      setupSmartMocks();
    });

    group('create', () {
      test('constructs new revision from meta and content', () async {
        final testAd = Uint8List.fromList([1, 2, 1]);
        const testMeta = EtebaseItemMetadata(name: 'test-meta');
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
            isWrapped('encoded(meta)', smConverterEncode, [
              testMeta.toJson(),
            ]),
          ]),
          isWrapped('cryptoMac(key)', smMac, [
            isTrue,
            isWrapped('notDeleted', smMacUpdate, [
              [0],
            ]),
            isWrapped('additionalData', smMacUpdateLen, [
              testAd,
            ]),
            isWrapped('chunksHash', smMacUpdate, [
              isWrapped('cryptoMac(noKey)', smMac, [
                isFalse,
                isWrapped('chunk[0].uid', smMacUpdate, [
                  base64.decode(result.chunks.single.uid),
                ]),
              ]),
            ]),
          ]),
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
          isWrapped('mac(content,key)', smCmMac, [
            testContent,
            isTrue,
          ]),
        );
        expectWrapped(
          result.chunks.first.data!,
          isWrapped('encrypted', smCmCrypt, [
            isWrapped('padded(content)', smCryptoPad, [
              testContent,
            ]),
            isNull,
          ]),
        );
      });

      test('constructs new revision with multiple chunks', () async {
        final testAd = Uint8List.fromList([5, 6, 5, 3, 2, 4, 2, 3]);
        const testMeta = EtebaseItemMetadata();
        final testContent = Uint8List.fromList(
          List.generate(
            1024 * 1024, // 1 MB
            (i) => i % 256,
          ),
        );

        final result = await EncryptedRevision.create(
          client: mockClient,
          cryptoManager: mockCryptoManager,
          additionalData: testAd,
          meta: testMeta,
          content: testContent,
        );

        expect(result.deleted, isFalse);
        expect(result.chunks, hasLength(2));
        expect(result.chunks.first.data, isNotNull);
      });
    });
  });
}
