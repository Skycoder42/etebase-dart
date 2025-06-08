// coverage:ignore-file

import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../codec/byte_array_converter.dart';
import 'login_response_user.dart';

part 'account_data.freezed.dart';
part 'account_data.g.dart';

@internal
@freezed
sealed class AccountData with _$AccountData {
  @msgPackBytes
  const factory AccountData({
    required LoginResponseUser user,
    required String authToken,
    required Uri serverUrl,
    required int version,
    required Uint8List key,
  }) = _AccountData;

  factory AccountData.fromJson(Map<String, dynamic> json) =>
      _$AccountDataFromJson(json);
}
