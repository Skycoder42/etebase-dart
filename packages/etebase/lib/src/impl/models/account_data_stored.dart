// coverage:ignore-file

import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../codec/byte_array_converter.dart';

part 'account_data_stored.freezed.dart';
part 'account_data_stored.g.dart';

@freezed
@internal
sealed class AccountDataStored with _$AccountDataStored {
  @msgPackBytes
  const factory({required int version, required Uint8List encryptedData}) =
      _AccountDataStored;

  factory fromJson(Map<String, dynamic> json) =>
      _$AccountDataStoredFromJson(json);
}
