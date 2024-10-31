import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../rest/converters/msg_pack_converters.dart';
import 'user.dart';

part 'account_data.freezed.dart';
part 'account_data.g.dart';

@internal
@freezed
sealed class AccountData with _$AccountData {
  @msgPackBytes
  const factory AccountData({
    required User user,
    required String authToken,
    required Uri serverUrl,
    required int version,
    required Uint8List key,
  }) = _AccountData;

  factory AccountData.fromJson(Map<String, dynamic> json) =>
      _$AccountDataFromJson(json);
}
