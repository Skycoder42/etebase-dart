import 'package:freezed_annotation/freezed_annotation.dart';

part 'etebase_isolate_config.freezed.dart';

@freezed
class EtebaseIsolateConfig with _$EtebaseIsolateConfig {
  const factory EtebaseIsolateConfig({
    @Default(1024) int defaultContentBufferSize,
  }) = _EtebaseIsolateConfig;
}
