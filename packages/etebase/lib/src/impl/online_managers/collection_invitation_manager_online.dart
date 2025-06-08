import 'package:meta/meta.dart';

import '../../api/models/fetch_options.dart';
import '../../api/models/list_response.dart';
import '../../api/models/user_profile.dart';
import '../models/invitation_accept_request.dart';
import '../models/signed_invitation_base.dart';
import 'base_manager.dart';
import 'base_network.dart';

@internal
class CollectionInvitationManagerOnline extends BaseManager {
  CollectionInvitationManagerOnline({
    required super.client,
    required super.authTokenSource,
  }) : super(path: const ['invitation']);

  @visibleForTesting
  CollectionInvitationManagerOnline.fromNetwork(
    super._network,
    super.authTokenSource,
    // ignore: invalid_use_of_visible_for_testing_member for tests
  ) : super.fromNetwork();

  Future<IteratorListResponse<SignedInvitationRead>> listIncoming(
    IteratorFetchOptions? options,
  ) => invoke<IteratorListResponse<SignedInvitationRead>>(
    path: const ['incoming'],
    options: options,
  );

  Future<IteratorListResponse<SignedInvitationRead>> listOutgoing(
    IteratorFetchOptions? options,
  ) => invoke<IteratorListResponse<SignedInvitationRead>>(
    path: const ['outgoing'],
    options: options,
  );

  Future<void> accept(
    SignedInvitationRead invitation,
    InvitationAcceptRequest body,
  ) => invoke<void>(
    method: HttpMethod.post,
    path: ['incoming', invitation.uid, 'accept'],
    body: body,
  );

  Future<void> reject(SignedInvitationRead invitation) => invoke<void>(
    method: HttpMethod.delete,
    path: ['incoming', invitation.uid],
  );

  Future<UserProfile> fetchUserProfile(String username) => invoke<UserProfile>(
    path: const ['outgoing', 'fetch_user_profile'],
    query: {'username': username},
  );

  Future<void> invite(SignedInvitationWrite invitation) => invoke<void>(
    method: HttpMethod.post,
    path: const ['outgoing'],
    body: invitation,
  );

  Future<void> disinvite(SignedInvitationRead invitation) => invoke<void>(
    method: HttpMethod.delete,
    path: ['outgoing', invitation.uid],
  );
}
