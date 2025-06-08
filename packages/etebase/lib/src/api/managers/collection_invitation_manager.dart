/// @docImport 'client.dart';
library;

import 'dart:typed_data';

import '../models/collection.dart';
import '../models/collection_access_level.dart';
import '../models/fetch_options.dart';
import '../models/list_response.dart';
import '../models/signed_invitation.dart';
import '../models/user_profile.dart';

/// An manager for managing user invitations to [Collection]s.
abstract class CollectionInvitationManager {
  /// Our identity's public key.
  ///
  /// This is the key users see when we send invitations.
  /// Can be pretty printed with [Client.prettyFingerprint].
  Uint8List get pubkey;

  /// List the incoming collection [SignedInvitation]s for the account.
  ///
  /// {@macro fetch_options}
  Future<IteratorListResponse<SignedInvitation>> listIncoming([
    IteratorFetchOptions? fetchOptions,
  ]);

  /// List the outgoing collection [SignedInvitation]s for the account.
  ///
  /// {@macro fetch_options}
  Future<IteratorListResponse<SignedInvitation>> listOutgoing([
    IteratorFetchOptions? fetchOptions,
  ]);

  /// Accept an [invitation].
  Future<void> accept(SignedInvitation invitation);

  /// Reject an [invitation].
  Future<void> reject(SignedInvitation invitation);

  /// Fetch and return a [UserProfile] for the given [username].
  Future<UserProfile> fetchUserProfile(String username);

  /// Invite a user identified by [username] to a collection.
  ///
  /// The [pubkey] must be the corresponding
  /// [CollectionInvitationManager.pubkey] of that user. The
  /// [accessLevel] defines the level of access to give to user.
  Future<void> invite(
    Collection collection,
    String username,
    Uint8List pubkey,
    CollectionAccessLevel accessLevel,
  );

  /// Cancel an [invitation] (disinvite the user).
  Future<void> disinvite(SignedInvitation invitation);
}
