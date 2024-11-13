import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../codec/msg_pack_converters.dart';

part 'login_challenge.freezed.dart';
part 'login_challenge.g.dart';

@internal
@freezed
sealed class LoginChallenge with _$LoginChallenge {
  @msgPackBytes
  const factory LoginChallenge({
    required Uint8List challenge,
    required Uint8List salt,
    required int version,
  }) = _LoginChallenge;

  factory LoginChallenge.fromJson(Map<String, dynamic> json) =>
      _$LoginChallengeFromJson(json);
}
