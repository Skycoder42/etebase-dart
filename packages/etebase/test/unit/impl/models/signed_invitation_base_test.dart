import 'dart:typed_data';

import 'package:dart_test_tools/test.dart';
import 'package:etebase/src/api/models/collection_access_level.dart';
import 'package:etebase/src/impl/models/signed_invitation_base.dart';
import 'package:test/test.dart';

void main() {
  group('$SignedInvitationBase', () {
    testData(
      'toJson does not add runtimeType',
      [
        SignedInvitationBase.write(
          uid: 'uid',
          version: 1,
          username: 'username',
          collection: 'collection',
          accessLevel: CollectionAccessLevel.admin,
          signedEncryptionKey: Uint8List.fromList([4, 4, 2, 1]),
        ),
        SignedInvitationBase.read(
          uid: 'uid',
          version: 1,
          username: 'username',
          collection: 'collection',
          accessLevel: CollectionAccessLevel.admin,
          signedEncryptionKey: Uint8List.fromList([6, 7, 2]),
          fromUsername: 'fromUsername',
          fromPubKey: Uint8List.fromList([9, 90]),
        ),
      ],
      (fixture) {
        final json = fixture.toJson();

        expect(json, isNot(contains('runtimeType')));
      },
    );
  });
}
