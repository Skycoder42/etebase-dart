import 'etebase_exception.dart';

/// A websocket connection was closed with an unexpected reason
class WebsocketClosed extends EtebaseException {
  /// The Websocket close code
  final int code;

  /// The Websocket close reason
  String get reason => message;

  /// Default constructor.
  new(this.code, [String? reason]) : super(reason ?? '<no reason>');

  @override
  String get name => 'WebsocketClosed';

  @override
  String toString() => '$name($code): $reason';
}
