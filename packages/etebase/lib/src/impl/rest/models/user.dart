import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../converters/msg_pack_converters.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@internal
@freezed
sealed class User with _$User {
  @msgPackBytes
  const factory User({
    required String username,
    required String email,
    required Uint8List pubkey,
    required Uint8List encryptedContent,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
