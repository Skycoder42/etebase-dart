import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../../api/managers/etebase_collection_invitation_manager.dart';
import '../../api/models/etebase_collection_access_level.dart';
import '../../api/models/etebase_fetch_options.dart';
import '../../api/models/etebase_list_response.dart';
import '../../api/models/etebase_user_profile.dart';
import '../models/invitation_accept_request.dart';
import '../models/signed_invitation.dart';
import '../models/signed_invitation_content.dart';
import '../online_managers/collection_invitation_manager_online.dart';
import 'account.dart';
import 'client.dart';
import 'collection.dart';

@internal
class CollectionInvitationManager
    implements EtebaseCollectionInvitationManager {
  final Client _client;
  final Account _account;
  final CollectionInvitationManagerOnline _online;

  CollectionInvitationManager(this._client, this._account, this._online);

  @override
  Uint8List get pubkey => _account.identityCryptoManager.pubkey;

  @override
  Future<EtebaseIteratorListResponse<SignedInvitationRead>> listIncoming([
    EtebaseIteratorFetchOptions? fetchOptions,
  ]) => _online.listIncoming(fetchOptions);

  @override
  Future<EtebaseIteratorListResponse<SignedInvitationRead>> listOutgoing([
    EtebaseIteratorFetchOptions? fetchOptions,
  ]) => _online.listOutgoing(fetchOptions);

  @override
  Future<void> accept(covariant SignedInvitationRead invitation) async {
    final content = _client.converter.decode<SignedInvitationContent>(
      _client.crypto.bufferUnpadSmall(
        await _account.identityCryptoManager.decrypt(
          nonceCipherText: invitation.signedEncryptionKey,
          pubkey: invitation.fromPubKey,
        ),
      ),
    );
    final colTypeUid = _account.accountCryptoManager.colTypeToUid(
      content.collectionType,
    );
    final encryptedEncryptionKey = await _account.accountCryptoManager.encrypt(
      content.encryptionKey,
      colTypeUid,
    );
    await _online.accept(
      invitation,
      InvitationAcceptRequest(
        collectionType: colTypeUid,
        encryptionKey: encryptedEncryptionKey,
      ),
    );
  }

  @override
  Future<void> reject(covariant SignedInvitationRead invitation) =>
      _online.reject(invitation);

  @override
  Future<EtebaseUserProfile> fetchUserProfile(String username) =>
      _online.fetchUserProfile(username);

  @override
  Future<void> invite(
    covariant Collection collection,
    String username,
    Uint8List pubkey,
    EtebaseCollectionAccessLevel accessLevel,
  ) async {
    final invitation = await collection.encrypted.createInvitation(
      _client,
      _account.accountCryptoManager,
      _account.identityCryptoManager,
      username,
      pubkey,
      accessLevel,
    );
    await _online.invite(invitation);
  }

  @override
  Future<void> disinvite(covariant SignedInvitationRead invitation) =>
      _online.disinvite(invitation);
}
