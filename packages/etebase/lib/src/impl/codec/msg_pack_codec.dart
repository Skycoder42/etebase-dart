import 'dart:convert';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:msgpack_dart/msgpack_dart.dart' as msg_pack;

import 'list_cast_codec.dart';

@internal
class MessagePackEncoder extends Converter<dynamic, Uint8List> {
  const MessagePackEncoder();

  @override
  Uint8List convert(dynamic input) => msg_pack.serialize(input);
}

@internal
class MessagePackDecoder extends Converter<Uint8List, dynamic> {
  const MessagePackDecoder();

  @override
  dynamic convert(Uint8List input) => msg_pack.deserialize(input);
}

@internal
class MessagePackCodec extends Codec<dynamic, Uint8List> {
  const MessagePackCodec();

  @override
  MessagePackEncoder get encoder => const MessagePackEncoder();

  @override
  MessagePackDecoder get decoder => const MessagePackDecoder();
}

/// @nodoc
@internal
const msgPack = MessagePackCodec();

@internal
class Base64UrlSafeNoPadEncoder extends Converter<Uint8List, String> {
  const Base64UrlSafeNoPadEncoder();

  @override
  String convert(Uint8List input) {
    final encoded = base64Url.encode(input);
    final paddingIndex = encoded.indexOf('=');
    return paddingIndex < 0 ? encoded : encoded.substring(0, paddingIndex);
  }
}

@internal
class Base64UrlSafeNoPadDecoder extends Converter<String, Uint8List> {
  const Base64UrlSafeNoPadDecoder();

  @override
  Uint8List convert(String input) {
    final extraBytes = input.length % 4;
    return base64Url.decode(
      extraBytes == 0 ? input : (input + ('=' * (4 - extraBytes))),
    );
  }
}

@internal
class Base64UrlSafeNoPadCodec extends Codec<Uint8List, String> {
  const Base64UrlSafeNoPadCodec();

  @override
  Base64UrlSafeNoPadEncoder get encoder => const Base64UrlSafeNoPadEncoder();

  @override
  Base64UrlSafeNoPadDecoder get decoder => const Base64UrlSafeNoPadDecoder();
}

/// @nodoc
@internal
const base64UrlNoPad = Base64UrlSafeNoPadCodec();

/// @nodoc
@internal
final msgPack64UrlNoPad =
    msgPack.fuse(const ListCastCodec().inverted).fuse(base64UrlNoPad);
