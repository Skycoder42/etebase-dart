import 'dart:typed_data';

import 'package:etebase/src/api/models/etebase_user_profile.dart';
import 'package:etebase/src/impl/codec/message_pack_converter.dart';
import 'package:meta/meta.dart';
import 'package:msgpack_codec/msgpack_codec.dart';
import 'package:test/test.dart';

@immutable
class CustomType {
  final int value;

  const CustomType(this.value);

  factory CustomType.fromJson(Map<String, dynamic> json) =>
      CustomType(json['value'] as int);

  Map<String, dynamic> toJson() => {'value': value};

  @override
  bool operator ==(Object other) => switch (other) {
        CustomType(:final value) when value == this.value => true,
        _ => false,
      };

  @override
  int get hashCode => value.hashCode;
}

void main() {
  group('$MessagePackConverter', () {
    final userProfile =
        EtebaseUserProfile(pubkey: Uint8List.fromList([1, 2, 4, 9]));
    final userProfileMsgPack = Uint8List.fromList([
      // map
      0x81, // 1000XXXX + 1
      // key1 - string
      0xa6, // 101XXXXX + 110
      // pubkey
      112, 117, 98, 107, 101, 121,
      // value1 - binary
      0xc4, 4,
      // the public key value
      1, 2, 4, 9,
    ]);
    const userProfileBase64 = 'gaZwdWJrZXnEBAECBAk';

    final sut = MessagePackConverter();

    group('encoding', () {
      group('encode', () {
        test('converts known type to message pack', () {
          expect(sut.encode(userProfile), userProfileMsgPack);
        });

        test('converts list of known type to message pack', () {
          expect(
            sut.encode([userProfile]),
            Uint8List.fromList([0x91]) + userProfileMsgPack,
          );
        });

        test('converts map of known type to message pack', () {
          expect(
            sut.encode({'p': userProfile}),
            Uint8List.fromList([0x81, 0xa1, 112]) + userProfileMsgPack,
          );
        });

        test('throws for unknown types', () {
          expect(
            () => sut.encode(42),
            throwsA(isNoSuchMethodError),
          );
          expect(
            () => sut.encode([42]),
            throwsA(isNoSuchMethodError),
          );
          expect(
            () => sut.encode({42: userProfile}),
            throwsA(isNoSuchMethodError),
          );
        });
      });

      test('encodeRaw uses message pack directly', () {
        expect(sut.encodeRaw(42), Uint8List.fromList([42]));
        expect(
          () => sut.encodeRaw(userProfile),
          throwsA(isA<MsgpackFormatException>()),
        );
      });

      test('encode64 converts encoded message pack to base64', () {
        expect(sut.encode64(userProfile), userProfileBase64);
      });

      test('encode64Raw uses message pack directly', () {
        expect(sut.encode64Raw(-1), '_w');
      });

      test('base64Encode encodes with custom base64 codec', () {
        expect(sut.base64Encode(Uint8List.fromList([-1])), '_w');
      });
    });

    group('decoding', () {
      group('encode', () {
        test('converts known type from message pack', () {
          expect(
            sut.decode<EtebaseUserProfile>(userProfileMsgPack),
            userProfile,
          );
        });

        test('throws for unknown types', () {
          expect(
            () => sut.decode<int>(Uint8List.fromList([42])),
            throwsA(isUnsupportedError),
          );
        });
      });

      test('decodeRaw uses message pack directly', () {
        expect(sut.decodeRaw(Uint8List.fromList([42])), 42);
      });

      test('decode64 converts encoded message pack to base64', () {
        expect(
          sut.decode64<EtebaseUserProfile>(userProfileBase64),
          userProfile,
        );
      });

      test('decode64Raw uses message pack directly', () {
        expect(sut.decode64Raw('_w'), -1);
      });

      test('base64Decode decodes with custom base64 codec', () {
        expect(sut.base64Decode('_w'), Uint8List.fromList([-1]));
      });
    });

    test('addCustom adds converter for custom encode/decode', () {
      const instance = CustomType(42);
      final data = Uint8List.fromList([
        // map
        0x81, // 1000XXXX + 1
        // key1 - string
        0xa5, // 101XXXXX + 101
        // value
        0x76, 0x61, 0x6C, 0x75, 0x65,
        // value1 - integer
        42,
      ]);

      sut.addCustom(CustomType.fromJson);

      expect(sut.encode(instance), data);
      expect(sut.decode<CustomType>(data), instance);
    });
  });
}
