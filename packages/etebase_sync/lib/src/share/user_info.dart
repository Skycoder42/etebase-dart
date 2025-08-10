import 'dart:typed_data';

import 'package:etebase/etebase.dart';

import '../account/etebase_sync.dart';

class UserInfo {
  final EtebaseSync _sync;
  final String username;
  final UserProfile _profile;

  const UserInfo(this._sync, this.username, this._profile);

  Uint8List get pubkey => _profile.pubkey;

  String get prettyFingerprint => _sync.prettyFingerprint(_profile.pubkey);

  String get _compactFingerprint =>
      _sync.prettyFingerprint(_profile.pubkey, '').replaceAll('\n', '-');

  @override
  String toString() => '$username (key: $_compactFingerprint)';
}

class MemberInfo extends UserInfo {
  final CollectionAccessLevel accessLevel;

  MemberInfo(super._sync, super.username, this.accessLevel, super._profile);

  @override
  String toString() =>
      '$username (accessLevel: ${accessLevel.name}, key: $_compactFingerprint)';
}
