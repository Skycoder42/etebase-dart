// coverage:ignore-file

import 'package:freezed_annotation/freezed_annotation.dart';

part 'web_socket_ticket_response.freezed.dart';
part 'web_socket_ticket_response.g.dart';

@freezed
@internal
sealed class WebSocketTicketResponse with _$WebSocketTicketResponse {
  const factory(String ticket) = _WebSocketTicketResponse;

  factory fromJson(Map<String, dynamic> json) =>
      _$WebSocketTicketResponseFromJson(json);
}
