import 'dart:async';
import 'dart:typed_data';

import 'package:etebase/etebase.dart';

abstract class ShareManager {
  final Collection _collection;
  final CollectionInvitationManager _collectionInvitationManager;
  final CollectionMemberManager _memberManager;

  ShareManager(
    this._collection,
    this._collectionInvitationManager,
    this._memberManager,
  );

  Stream<SignedInvitation> listInvitations() async* {
    IteratorListResponse<SignedInvitation>? response;
    do {
      response = await _collectionInvitationManager.listOutgoing(
        IteratorFetchOptions(iterator: response?.iterator),
      );
      for (final invitation in response.data) {
        if (invitation.collection == _collection.uid) {
          yield invitation;
        }
      }
    } while (!response.isDone);
  }

  Future<void> invite(
    String username,
    CollectionAccessLevel accessLevel,
  ) async {
    final profile = await _collectionInvitationManager.fetchUserProfile(
      username,
    );
    if (!await validateUserProfile(username, profile)) {
      throw UnimplementedError(); // TODO
    }

    await _collectionInvitationManager.invite(
      _collection,
      username,
      profile.pubkey,
      accessLevel,
    );
  }

  Future<void> disinvite(SignedInvitation invitation) async {
    if (invitation.collection != _collection.uid) {
      throw ArgumentError.value(
        invitation,
        'invitation',
        'invitation must be for collection ${_collection.uid}, '
            'but is for ${invitation.collection}',
      );
    }
    await _collectionInvitationManager.disinvite(invitation);
  }

  Stream<CollectionMember> listMembers() async* {
    IteratorListResponse<CollectionMember>? response;
    do {
      response = await _memberManager.list(
        IteratorFetchOptions(iterator: response?.iterator),
      );
      for (final member in response.data) {
        yield member;
      }
    } while (!response.isDone);
  }

  // TODO here

  FutureOr<bool> validateUserProfile(String username, UserProfile profile);
}
