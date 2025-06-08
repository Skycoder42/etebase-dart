import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../../api/managers/collection_invitation_manager.dart';
import '../../api/models/collection_access_level.dart';
import '../../api/models/fetch_options.dart';
import '../../api/models/list_response.dart';
import '../../api/models/user_profile.dart';
import '../models/invitation_accept_request.dart';
import '../models/signed_invitation_base.dart';
import '../models/signed_invitation_content.dart';
import '../online_managers/collection_invitation_manager_online.dart';
import 'account_impl.dart';
import 'client_impl.dart';
import 'collection_impl.dart';

@internal
class CollectionInvitationManagerImpl implements CollectionInvitationManager {
  final ClientImpl _client;
  final AccountImpl _account;
  final CollectionInvitationManagerOnline _online;

  CollectionInvitationManagerImpl(this._client, this._account, this._online);

  @override
  Uint8List get pubkey => _account.identityCryptoManager.pubkey;

  @override
  Future<IteratorListResponse<SignedInvitationRead>> listIncoming([
    IteratorFetchOptions? fetchOptions,
  ]) => _online.listIncoming(fetchOptions);

  @override
  Future<IteratorListResponse<SignedInvitationRead>> listOutgoing([
    IteratorFetchOptions? fetchOptions,
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
  Future<UserProfile> fetchUserProfile(String username) =>
      _online.fetchUserProfile(username);

  @override
  Future<void> invite(
    covariant CollectionImpl collection,
    String username,
    Uint8List pubkey,
    CollectionAccessLevel accessLevel,
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
