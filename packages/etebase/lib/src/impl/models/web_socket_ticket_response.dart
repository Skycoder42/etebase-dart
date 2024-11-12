import 'package:freezed_annotation/freezed_annotation.dart';

part 'web_socket_ticket_response.freezed.dart';
part 'web_socket_ticket_response.g.dart';

@freezed
@internal
sealed class WebSocketTicketResponse with _$WebSocketTicketResponse {
  const factory WebSocketTicketResponse(String ticket) =
      _WebSocketTicketResponse;

  factory WebSocketTicketResponse.fromJson(Map<String, dynamic> json) =>
      _$WebSocketTicketResponseFromJson(json);
}
