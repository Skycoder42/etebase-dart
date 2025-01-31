import 'dart:convert';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:msgpack_codec/msgpack_codec.dart';

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
  Uint8List convert(String input) =>
      base64Url.decode(base64Url.normalize(input));
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
final msgPack64UrlNoPad = msgPack.fuse(base64UrlNoPad);
