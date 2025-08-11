import 'dart:async';

import 'package:etebase/etebase.dart';

import '../account/etebase_sync.dart';
import '../exceptions/user_profile_mismatch.dart';
import 'share_callbacks.dart';
import 'user_info.dart';

typedef OnLeaveCallback = Future<void> Function(String colUid);

class ShareManager {
  final EtebaseSync _sync;
  final Collection _collection;
  final CollectionInvitationManager _invitationManager;
  final CollectionMemberManager _memberManager;
  final ShareCallbacks _invitationUserValidator;
  final OnLeaveCallback _onLeaveCallback;

  ShareManager(
    this._sync,
    this._collection,
    this._invitationManager,
    this._memberManager,
    this._invitationUserValidator,
    this._onLeaveCallback,
  );

  void dispose() {
    _collection.dispose();
  }

  Stream<SignedInvitation> listInvitations() async* {
    IteratorListResponse<SignedInvitation>? response;
    do {
      response = await _invitationManager.listOutgoing(
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
    final profile = await _invitationManager.fetchUserProfile(username);
    if (!await _invitationUserValidator.validateUserForInvite(
      _collection.uid,
      UserInfo(_sync, username, profile),
    )) {
      throw UserProfileMismatch(username, profile);
    }

    await _invitationManager.invite(
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
    await _invitationManager.disinvite(invitation);
  }

  Stream<MemberInfo> listMembers() async* {
    IteratorListResponse<CollectionMember>? response;
    do {
      response = await _memberManager.list(
        IteratorFetchOptions(iterator: response?.iterator),
      );
      for (final member in response.data) {
        final profile = await _invitationManager.fetchUserProfile(
          member.username,
        );
        yield MemberInfo(_sync, member.username, member.accessLevel, profile);
      }
    } while (!response.isDone);
  }

  Future<void> remove(String username) async =>
      await _memberManager.remove(username);

  Future<void> modifyAccessLevel(
    String username,
    CollectionAccessLevel accessLevel,
  ) async => await _memberManager.modifyAccessLevel(username, accessLevel);

  Future<void> leave() async {
    await _memberManager.leave();
    await _onLeaveCallback(_collection.uid);
  }
}
