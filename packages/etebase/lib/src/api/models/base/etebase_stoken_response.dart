import 'etebase_response.dart';

abstract interface class EtebaseStokenResponse<T>
    implements EtebaseResponse<T> {
  String? get stoken;
}
