import 'dart:typed_data';

import '../models/etebase_collection.dart';
import '../models/etebase_collection_access_level.dart';
import '../models/etebase_fetch_options.dart';
import '../models/etebase_invitation_list_response.dart';
import '../models/etebase_signed_invitation.dart';
import '../models/etebase_user_profile.dart';

/// The dart binding of the EtebaseCollectionInvitationManager rust class
abstract class EtebaseCollectionInvitationManager {
  /// List the incoming collection invitations for the account
  ///
  /// @param this_ the object handle
  /// @param fetch_options the `EtebaseFetchOptions` to fetch with
  Future<EtebaseInvitationListResponse> listIncoming([
    EtebaseFetchOptions? fetchOptions,
  ]);

  /// List the outgoing collection invitations for the account
  ///
  /// @param this_ the object handle
  /// @param fetch_options the `EtebaseFetchOptions` to fetch with
  Future<EtebaseInvitationListResponse> listOutgoing([
    EtebaseFetchOptions? fetchOptions,
  ]);

  /// Accept an invitation
  ///
  /// @param this_ the object handle
  /// @param invitation the invitation to accept
  Future<void> accept(EtebaseSignedInvitation invitation);

  /// Reject an invitation
  ///
  /// @param this_ the object handle
  /// @param invitation the invitation to reject
  Future<void> reject(EtebaseSignedInvitation invitation);

  /// Fetch and return a user's profile
  ///
  /// @param this_ the object handle
  /// @param username the username of the user to fetch
  Future<EtebaseUserProfile> fetchUserProfile(String username);

  /// Invite a user to a collection
  ///
  /// @param this_ the object handle
  /// @param collection the collection to invite to
  /// @param username the username of the user to invite
  /// @param pubkey the public key of the user to invite
  /// @param pubkey_size the size of the public key
  /// @param access_level the level of access to give to user
  Future<void> invite(
    EtebaseCollection collection,
    String username,
    Uint8List pubkey,
    EtebaseCollectionAccessLevel accessLevel,
  );

  /// Cancel an invitation (disinvite)
  ///
  /// @param this_ the object handle
  /// @param invitation the invitation to cancel
  Future<void> disinvite(EtebaseSignedInvitation invitation);

  /// Our identity's public key
  ///
  /// This is the key users see when we send invitations.
  /// Can be pretty printed with `etebase_utils_pretty_fingerprint`.
  ///
  /// @param this_ the object handle
  Uint8List get pubkey;
}
