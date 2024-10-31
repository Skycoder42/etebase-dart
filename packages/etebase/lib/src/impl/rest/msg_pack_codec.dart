import 'dart:convert';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:msgpack_dart/msgpack_dart.dart' as msg_pack;

@internal
class MessagePackEncoder extends Converter<dynamic, Uint8List> {
  const MessagePackEncoder();

  @override
  Uint8List convert(dynamic input) =>
      // ignore: avoid_dynamic_calls
      msg_pack.serialize(input.toJson());
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
  MessagePackDecoder get decoder => const MessagePackDecoder();

  @override
  MessagePackEncoder get encoder => const MessagePackEncoder();
}

@internal
const msgPack = MessagePackCodec();
