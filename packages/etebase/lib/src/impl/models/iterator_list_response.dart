// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../api/models/base/etebase_iterator_list_response.dart';

part 'iterator_list_response.freezed.dart';
part 'iterator_list_response.g.dart';

@internal
@Freezed(fromJson: false, toJson: false)
sealed class IteratorListResponse<T>
    with _$IteratorListResponse<T>
    implements EtebaseIteratorListResponse<T> {
  @JsonSerializable(genericArgumentFactories: true)
  const factory IteratorListResponse({
    required List<T> data,
    @JsonKey(name: 'done') required bool isDone,
    required String iterator,
  }) = _IteratorListResponse<T>;

  factory IteratorListResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$$IteratorListResponseImplFromJson<T>(json, fromJsonT);

  const IteratorListResponse._();

  /// @nodoc
  @internal
  Map<String, dynamic> toJson() => _$$IteratorListResponseImplToJson(
        this as _$IteratorListResponseImpl<T>,
        (dynamic i) => i.toJson(),
      );

  /// @nodoc
  @internal
  Future<IteratorListResponse<TOther>> mapAsync<TOther>(
    Future<TOther> Function(T) map,
  ) async =>
      IteratorListResponse(
        data: [
          for (final item in data) await map(item),
        ],
        isDone: isDone,
        iterator: iterator,
      );
}
