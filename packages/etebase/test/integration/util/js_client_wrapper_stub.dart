import 'package:freezed_annotation/freezed_annotation.dart';

part 'js_client_wrapper_stub.freezed.dart';
part 'js_client_wrapper_stub.g.dart';

@Freezed(unionKey: 'action')
sealed class Action with _$Action {
  // account test
  const factory Action.signUp(String username, String email, String password) =
      _SignUp;
  const factory Action.signIn(String username, String password) = _SignIn;
  const factory Action.saveAccount(
    String username,
    String password,
    String encryptionKey,
  ) = _SaveAccount;
  const factory Action.restoreAccount(String data, String encryptionKey) =
      _RestoreAccount;

  factory Action.fromJson(Map<String, dynamic> json) => _$ActionFromJson(json);

  const Action._();

  @internal
  String get $type;
}

abstract base class JsClientWrapper {
  static Future<TRes> execute<TRes>(
    Action action, {
    bool useDefaultServer = false,
    TRes Function(Map<String, dynamic> json)? fromJson,
  }) => throw UnsupportedError('Unsupported platform');
}
