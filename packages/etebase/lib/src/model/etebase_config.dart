// coverage:ignore-file

import 'package:freezed_annotation/freezed_annotation.dart';

part 'etebase_config.freezed.dart';

/// A configuration to set global parameters for etebase.
@freezed
class EtebaseConfig with _$EtebaseConfig {
  /// Default constructor.
  const factory EtebaseConfig({
    /// The size of getContent buffer allocations if no explicit size is given.
    ///
    /// Please note that this is just a hint. A buffer will be allocated with
    /// the given size and then the library tries to read the content into the
    /// buffer. If the content has less or an equal amount of bytes, it
    /// succeeds. Otherwise, a new buffer with the correct size is allocated and
    /// the data is read into that.
    ///
    /// This means this size hint is simply a ways of optimizing reads. The
    /// default value is 1024 bytes.
    @Default(1024) int defaultContentBufferSize,
  }) = _EtebaseConfig;
}
