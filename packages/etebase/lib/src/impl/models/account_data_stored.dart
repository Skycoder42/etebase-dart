import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../codec/byte_array_converter.dart';

part 'account_data_stored.freezed.dart';
part 'account_data_stored.g.dart';

@freezed
@internal
sealed class AccountDataStored with _$AccountDataStored {
  @msgPackBytes
  const factory AccountDataStored({
    required int version,
    required Uint8List encryptedData,
  }) = _AccountDataStored;

  factory AccountDataStored.fromJson(Map<String, dynamic> json) =>
      _$AccountDataStoredFromJson(json);
}
