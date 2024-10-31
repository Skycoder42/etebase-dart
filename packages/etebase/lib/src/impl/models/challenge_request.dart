import 'package:freezed_annotation/freezed_annotation.dart';

part 'challenge_request.freezed.dart';
part 'challenge_request.g.dart';

@internal
@freezed
sealed class ChallengeRequest with _$ChallengeRequest {
  const factory ChallengeRequest({
    required String username,
  }) = _ChallengeRequest;

  factory ChallengeRequest.fromJson(Map<String, dynamic> json) =>
      _$ChallengeRequestFromJson(json);
}
