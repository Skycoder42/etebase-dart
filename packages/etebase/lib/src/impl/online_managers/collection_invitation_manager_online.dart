import 'package:meta/meta.dart';

import '../../api/models/etebase_fetch_options.dart';
import '../../api/models/etebase_user_profile.dart';
import '../models/invitation_accept_request.dart';
import '../models/iterator_list_response.dart';
import '../models/signed_invitation.dart';
import 'base_manager.dart';
import 'base_network.dart';

@internal
final class CollectionInvitationManagerOnline extends BaseManager {
  CollectionInvitationManagerOnline({
    required super.client,
    required super.authTokenSource,
  }) : super(path: const ['invitation']);

  Future<IteratorListResponse<SignedInvitationRead>> listIncoming(
    EtebaseIteratorFetchOptions? options,
  ) =>
      invokeApi<IteratorListResponse<SignedInvitationRead>>(
        path: const ['incoming'],
      );

  Future<IteratorListResponse<SignedInvitationRead>> listOutgoing(
    EtebaseIteratorFetchOptions? options,
  ) =>
      invokeApi<IteratorListResponse<SignedInvitationRead>>(
        path: const ['outgoing'],
      );

  Future<void> accept(
    SignedInvitationRead invitation,
    InvitationAcceptRequest body,
  ) =>
      invokeApi<void>(
        method: HttpMethod.post,
        path: ['incoming', invitation.uid, 'accept'],
        body: body,
      );

  Future<void> reject(SignedInvitationRead invitation) => invokeApi<void>(
        method: HttpMethod.delete,
        path: ['incoming', invitation.uid],
      );

  Future<EtebaseUserProfile> fetchUserProfile(String username) =>
      invokeApi<EtebaseUserProfile>(
        path: const ['outgoing', 'fetch_user_profile'],
        query: {'username': username},
      );

  Future<void> invite(SignedInvitationWrite invitation) => invokeApi<void>(
        method: HttpMethod.post,
        path: const ['outgoing'],
        body: invitation,
      );

  Future<void> disinvite(SignedInvitationRead invitation) => invokeApi<void>(
        method: HttpMethod.delete,
        path: ['outgoing', invitation.uid],
      );
}
