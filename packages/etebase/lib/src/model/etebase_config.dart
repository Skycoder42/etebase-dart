import 'package:freezed_annotation/freezed_annotation.dart';

part 'etebase_config.freezed.dart';

@freezed
class EtebaseConfig with _$EtebaseConfig {
  const factory EtebaseConfig({
    @Default(1024) int defaultContentBufferSize,
  }) = _EtebaseConfig;
}
