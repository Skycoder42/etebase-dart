import 'dart:typed_data';

import '../models/etebase_collection.dart';
import '../models/etebase_collection_access_level.dart';
import '../models/etebase_fetch_options.dart';
import '../models/etebase_list_response.dart';
import '../models/etebase_signed_invitation.dart';
import '../models/etebase_user_profile.dart';
import 'etebase_utils.dart';

/// An manager for managing user invitations to [EtebaseCollection]s.
abstract class EtebaseCollectionInvitationManager {
  /// Our identity's public key.
  ///
  /// This is the key users see when we send invitations.
  /// Can be pretty printed with [EtebaseUtils.prettyFingerprint].
  Uint8List get pubkey;

  /// List the incoming collection [EtebaseSignedInvitation]s for the account.
  ///
  /// {@macro fetch_options}
  Future<EtebaseIteratorListResponse<EtebaseSignedInvitation>> listIncoming([
    EtebaseIteratorFetchOptions? fetchOptions,
  ]);

  /// List the outgoing collection [EtebaseSignedInvitation]s for the account.
  ///
  /// {@macro fetch_options}
  Future<EtebaseIteratorListResponse<EtebaseSignedInvitation>> listOutgoing([
    EtebaseIteratorFetchOptions? fetchOptions,
  ]);

  /// Accept an [invitation].
  Future<void> accept(EtebaseSignedInvitation invitation);

  /// Reject an [invitation].
  Future<void> reject(EtebaseSignedInvitation invitation);

  /// Fetch and return a [EtebaseUserProfile] for the given [username].
  Future<EtebaseUserProfile> fetchUserProfile(String username);

  /// Invite a user identified by [username] to a collection.
  ///
  /// The [pubkey] must be the corresponding
  /// [EtebaseCollectionInvitationManager.pubkey] of that user. The
  /// [accessLevel] defines the level of access to give to user.
  Future<void> invite(
    EtebaseCollection collection,
    String username,
    Uint8List pubkey,
    EtebaseCollectionAccessLevel accessLevel,
  );

  /// Cancel an [invitation] (disinvite the user).
  Future<void> disinvite(EtebaseSignedInvitation invitation);
}
