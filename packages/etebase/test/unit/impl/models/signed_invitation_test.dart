import 'dart:typed_data';

import 'package:dart_test_tools/test.dart';
import 'package:etebase/src/api/models/etebase_collection_access_level.dart';
import 'package:etebase/src/impl/models/signed_invitation.dart';
import 'package:test/test.dart';

void main() {
  group('$SignedInvitation', () {
    testData(
      'toJson does not add runtimeType',
      [
        SignedInvitation.write(
          uid: 'uid',
          version: 1,
          username: 'username',
          collection: 'collection',
          accessLevel: EtebaseCollectionAccessLevel.admin,
          signedEncryptionKey: Uint8List.fromList([4, 4, 2, 1]),
        ),
        SignedInvitation.read(
          uid: 'uid',
          version: 1,
          username: 'username',
          collection: 'collection',
          accessLevel: EtebaseCollectionAccessLevel.admin,
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
