import 'dart:convert';
import 'dart:typed_data';

import 'package:meta/meta.dart';

import 'msg_pack_codec.dart';

@internal
class MessagePackConverter {
  const MessagePackConverter();

  Uint8List encode(dynamic data) => msgPack.encode(data);

  String encode64(dynamic data) => msgPack64.encode(data);

  String base64Encode(Uint8List data) => base64.encode(data);

  dynamic decodeRaw(Uint8List data) => msgPack.decode(data);

  dynamic decode64Raw(String data) => msgPack64.decode(data);

  T decode<T>(Uint8List data, T Function(Map<String, dynamic> json) fromJson) {
    final rawData = decodeRaw(data);
    return fromJson((rawData as Map).cast());
  }

  T decode64<T>(String data, T Function(Map<String, dynamic> json) fromJson) {
    final rawData = decode64Raw(data);
    return fromJson((rawData as Map).cast());
  }

  Uint8List base64Decode(String data) => base64.decode(data);
}
