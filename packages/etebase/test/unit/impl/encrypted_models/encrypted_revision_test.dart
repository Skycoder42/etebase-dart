// ignore_for_file: prefer_asserts_with_message

import 'dart:convert';
import 'dart:typed_data';

import 'package:etebase/src/api/models/etebase_item_metadata.dart';
import 'package:etebase/src/impl/codec/message_pack_converter.dart';
import 'package:etebase/src/impl/crypto/collection_item_crypto_manager.dart';
import 'package:etebase/src/impl/crypto/crypto_mac.dart';
import 'package:etebase/src/impl/crypto/crypto_service.dart';
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
])
import 'encrypted_revision_test.mocks.dart';

void main() {
  group('$EncryptedRevision', () {
    const smartMockPrefix = 0x42;

    final mockClient = MockClient();
    final mockCryptoService = MockCryptoService();
    final mockMessagePackConverter = MockMessagePackConverter();
    final mockCryptoManager = MockCollectionItemCryptoManager();
    final mockCryptoMac = MockCryptoMac();
    final mockCryptoMacNoKey = MockCryptoMac();

    Uint8List wrap(int id, List<dynamic> data) => msgPack.encode([
          // header
          0x42, id,
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

    void setupSmartMocks() {
      when(mockClient.converter).thenReturn(mockMessagePackConverter);

      var encodedCacheCtr = 0;
      final encodeCache = <int, dynamic>{};
      when(mockMessagePackConverter.encode(any)).thenAnswer((i) {
        final [dynamic data] = i.positionalArguments;
        final idx = encodedCacheCtr++;
        encodeCache[idx] = data;
        return wrap(0x01, [data.runtimeType.toString(), idx]);
      });
      when(mockMessagePackConverter.decode<dynamic>(any)).thenAnswer((i) {
        final [Uint8List data] = i.positionalArguments;
        final [String typeName, int idx] = unwrap(data, 0x01);
        expect(encodeCache, contains(idx));
        final value = encodeCache[idx];
        expect(value.runtimeType.toString(), typeName);
        return value;
      });
      when(mockMessagePackConverter.encodeRaw(any)).thenAnswer((i) {
        final [dynamic data] = i.positionalArguments;
        final idx = encodedCacheCtr++;
        encodeCache[idx] = data;
        return wrap(0x02, [data.runtimeType.toString(), idx]);
      });
      when(mockMessagePackConverter.decodeRaw(any)).thenAnswer((i) {
        final [Uint8List data] = i.positionalArguments;
        final [String typeName, int idx] = unwrap(data, 0x02);
        expect(encodeCache, contains(idx));
        final value = encodeCache[idx];
        expect(value.runtimeType.toString(), typeName);
        return value;
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
        return wrap(0x11, [data]);
      });
      when(mockCryptoService.bufferUnpadSmall(any)).thenAnswer((i) {
        final [Uint8List raw] = i.positionalArguments;
        final [Uint8List data] = unwrap(raw, 0x11);
        return data;
      });
      // ignore: discarded_futures
      when(mockCryptoService.bufferPad(any)).thenAnswer((i) {
        final [Uint8List data] = i.positionalArguments;
        return wrap(0x12, [data]);
      });
      // ignore: discarded_futures
      when(mockCryptoService.bufferUnpad(any)).thenAnswer((i) {
        final [Uint8List raw] = i.positionalArguments;
        final [Uint8List data] = unwrap(raw, 0x12);
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
        final cipher = wrap(0x21, [msg, ad]);
        final mac = wrap(0x22, [msg, ad]);
        return (mac: mac, nonceCipherText: cipher);
      });
      // ignore: discarded_futures
      when(mockCryptoManager.decryptDetached(any, any, any)).thenAnswer((i) {
        final [Uint8List cipher, Uint8List mac, Uint8List? ad] =
            i.positionalArguments;
        final [Uint8List msgC, Uint8List? adC] = unwrap(cipher, 0x21);
        final [Uint8List msgM, Uint8List? adM] = unwrap(mac, 0x22);
        expect(adC, ad);
        expect(adM, ad);
        expect(msgM, msgC);
        return msgC;
      });
      // ignore: discarded_futures
      when(mockCryptoManager.verify(any, any, any)).thenAnswer((i) {
        final [Uint8List cipher, Uint8List mac, Uint8List? ad] =
            i.positionalArguments;
        final [Uint8List msgC, Uint8List? adC] = unwrap(cipher, 0x21);
        final [Uint8List msgM, Uint8List? adM] = unwrap(mac, 0x22);
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
        return wrap(0x23, [message, withKey]);
      });
      // ignore: discarded_futures
      when(mockCryptoManager.encrypt(any, any)).thenAnswer((i) {
        final [Uint8List msg, Uint8List? ad] = i.positionalArguments;
        final cipher = wrap(0x24, [msg, ad]);
        return cipher;
      });
      // ignore: discarded_futures
      when(mockCryptoManager.decrypt(any, any)).thenAnswer((i) {
        final [Uint8List cipher, Uint8List? ad] = i.positionalArguments;
        final [Uint8List msgC, Uint8List? adC] = unwrap(cipher, 0x24);
        expect(adC, ad);
        return msgC;
      });

      when(mockCryptoManager.getCryptoMac(withKey: anyNamed('withKey')))
          .thenAnswer((i) {
        final {#withKey: bool withKey} = i.namedArguments;
        final buffer = BytesBuilder()..add(wrap(0x31, [withKey]));
        final cm = MockCryptoMac();
        when(cm.update(any)).thenAnswer((i) {
          final [Uint8List data] = i.positionalArguments;
          buffer.add(wrap(0x32, data));
        });
        when(cm.updateWithLenPrefix(any)).thenAnswer((i) {
          final [Uint8List data] = i.positionalArguments;
          buffer.add(wrap(0x33, data));
        });
        // ignore: discarded_futures
        when(cm.finalize()).thenAnswer((i) async => buffer.takeBytes());
        return cm;
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

    test('create creates new revision from meta and content', () async {
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

      expect(
        result.verify(mockClient, mockCryptoManager, testAd),
        completion(isTrue),
      );

      expect(
        result.getMeta(mockClient, mockCryptoManager, testAd),
        completion(testMeta),
      );

      expect(
        result.getContent(mockClient, mockCryptoManager),
        completion(testContent),
      );
    });
  });
}
