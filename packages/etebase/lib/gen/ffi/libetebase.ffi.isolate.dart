// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// EtebaseIsolateGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import '../../src/isolate/method_invocation.dart' as _i3;
import '../../src/isolate/method_result.dart' as _i1;
import 'libetebase.ffi.dart' as _i2;

_i1.MethodResult etebaseIsolateMessageHandler(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  switch (invocation.method) {
    case #etebase_user_profile_get_pubkey:
      return _etebase_user_profile_get_pubkey(
        libEtebase,
        invocation,
      );
    case #etebase_user_profile_get_pubkey_size:
      return _etebase_user_profile_get_pubkey_size(
        libEtebase,
        invocation,
      );
    case #etebase_user_profile_destroy:
      return _etebase_user_profile_destroy(
        libEtebase,
        invocation,
      );
    case #etebase_user_new:
      return _etebase_user_new(
        libEtebase,
        invocation,
      );
    case #etebase_user_set_username:
      return _etebase_user_set_username(
        libEtebase,
        invocation,
      );
    case #etebase_user_get_username:
      return _etebase_user_get_username(
        libEtebase,
        invocation,
      );
    case #etebase_user_set_email:
      return _etebase_user_set_email(
        libEtebase,
        invocation,
      );
    case #etebase_user_get_email:
      return _etebase_user_get_email(
        libEtebase,
        invocation,
      );
    case #etebase_user_destroy:
      return _etebase_user_destroy(
        libEtebase,
        invocation,
      );
    case #etebase_signed_invitation_clone:
      return _etebase_signed_invitation_clone(
        libEtebase,
        invocation,
      );
    case #etebase_signed_invitation_get_uid:
      return _etebase_signed_invitation_get_uid(
        libEtebase,
        invocation,
      );
    case #etebase_signed_invitation_get_username:
      return _etebase_signed_invitation_get_username(
        libEtebase,
        invocation,
      );
    case #etebase_signed_invitation_get_collection:
      return _etebase_signed_invitation_get_collection(
        libEtebase,
        invocation,
      );
    case #etebase_signed_invitation_get_access_level:
      return _etebase_signed_invitation_get_access_level(
        libEtebase,
        invocation,
      );
    case #etebase_signed_invitation_get_from_username:
      return _etebase_signed_invitation_get_from_username(
        libEtebase,
        invocation,
      );
    case #etebase_signed_invitation_get_from_pubkey:
      return _etebase_signed_invitation_get_from_pubkey(
        libEtebase,
        invocation,
      );
    case #etebase_signed_invitation_get_from_pubkey_size:
      return _etebase_signed_invitation_get_from_pubkey_size(
        libEtebase,
        invocation,
      );
    case #etebase_signed_invitation_destroy:
      return _etebase_signed_invitation_destroy(
        libEtebase,
        invocation,
      );
    case #etebase_removed_collection_get_uid:
      return _etebase_removed_collection_get_uid(
        libEtebase,
        invocation,
      );
    case #etebase_removed_collection_destroy:
      return _etebase_removed_collection_destroy(
        libEtebase,
        invocation,
      );
    case #etebase_invitation_list_response_get_iterator:
      return _etebase_invitation_list_response_get_iterator(
        libEtebase,
        invocation,
      );
    case #etebase_invitation_list_response_get_data:
      return _etebase_invitation_list_response_get_data(
        libEtebase,
        invocation,
      );
    case #etebase_invitation_list_response_get_data_length:
      return _etebase_invitation_list_response_get_data_length(
        libEtebase,
        invocation,
      );
    case #etebase_invitation_list_response_is_done:
      return _etebase_invitation_list_response_is_done(
        libEtebase,
        invocation,
      );
    case #etebase_invitation_list_response_destroy:
      return _etebase_invitation_list_response_destroy(
        libEtebase,
        invocation,
      );
    case #etebase_item_revisions_list_response_get_iterator:
      return _etebase_item_revisions_list_response_get_iterator(
        libEtebase,
        invocation,
      );
    case #etebase_item_revisions_list_response_get_data:
      return _etebase_item_revisions_list_response_get_data(
        libEtebase,
        invocation,
      );
    case #etebase_item_revisions_list_response_get_data_length:
      return _etebase_item_revisions_list_response_get_data_length(
        libEtebase,
        invocation,
      );
    case #etebase_item_revisions_list_response_is_done:
      return _etebase_item_revisions_list_response_is_done(
        libEtebase,
        invocation,
      );
    case #etebase_item_revisions_list_response_destroy:
      return _etebase_item_revisions_list_response_destroy(
        libEtebase,
        invocation,
      );
    case #etebase_member_list_response_get_iterator:
      return _etebase_member_list_response_get_iterator(
        libEtebase,
        invocation,
      );
    case #etebase_member_list_response_get_data:
      return _etebase_member_list_response_get_data(
        libEtebase,
        invocation,
      );
    case #etebase_member_list_response_get_data_length:
      return _etebase_member_list_response_get_data_length(
        libEtebase,
        invocation,
      );
    case #etebase_member_list_response_is_done:
      return _etebase_member_list_response_is_done(
        libEtebase,
        invocation,
      );
    case #etebase_member_list_response_destroy:
      return _etebase_member_list_response_destroy(
        libEtebase,
        invocation,
      );
    case #etebase_item_metadata_new:
      return _etebase_item_metadata_new(
        libEtebase,
        invocation,
      );
    case #etebase_item_metadata_set_item_type:
      return _etebase_item_metadata_set_item_type(
        libEtebase,
        invocation,
      );
    case #etebase_item_metadata_get_item_type:
      return _etebase_item_metadata_get_item_type(
        libEtebase,
        invocation,
      );
    case #etebase_item_metadata_set_name:
      return _etebase_item_metadata_set_name(
        libEtebase,
        invocation,
      );
    case #etebase_item_metadata_get_name:
      return _etebase_item_metadata_get_name(
        libEtebase,
        invocation,
      );
    case #etebase_item_metadata_set_mtime:
      return _etebase_item_metadata_set_mtime(
        libEtebase,
        invocation,
      );
    case #etebase_item_metadata_get_mtime:
      return _etebase_item_metadata_get_mtime(
        libEtebase,
        invocation,
      );
    case #etebase_item_metadata_set_description:
      return _etebase_item_metadata_set_description(
        libEtebase,
        invocation,
      );
    case #etebase_item_metadata_get_description:
      return _etebase_item_metadata_get_description(
        libEtebase,
        invocation,
      );
    case #etebase_item_metadata_set_color:
      return _etebase_item_metadata_set_color(
        libEtebase,
        invocation,
      );
    case #etebase_item_metadata_get_color:
      return _etebase_item_metadata_get_color(
        libEtebase,
        invocation,
      );
    case #etebase_item_metadata_destroy:
      return _etebase_item_metadata_destroy(
        libEtebase,
        invocation,
      );
    case #etebase_item_manager_fetch:
      return _etebase_item_manager_fetch(
        libEtebase,
        invocation,
      );
    case #etebase_item_manager_create:
      return _etebase_item_manager_create(
        libEtebase,
        invocation,
      );
    case #etebase_item_manager_create_raw:
      return _etebase_item_manager_create_raw(
        libEtebase,
        invocation,
      );
    case #etebase_item_manager_list:
      return _etebase_item_manager_list(
        libEtebase,
        invocation,
      );
    case #etebase_item_manager_item_revisions:
      return _etebase_item_manager_item_revisions(
        libEtebase,
        invocation,
      );
    case #etebase_item_manager_fetch_updates:
      return _etebase_item_manager_fetch_updates(
        libEtebase,
        invocation,
      );
    case #etebase_item_manager_fetch_multi:
      return _etebase_item_manager_fetch_multi(
        libEtebase,
        invocation,
      );
    case #etebase_item_manager_batch:
      return _etebase_item_manager_batch(
        libEtebase,
        invocation,
      );
    case #etebase_item_manager_batch_deps:
      return _etebase_item_manager_batch_deps(
        libEtebase,
        invocation,
      );
    case #etebase_item_manager_transaction:
      return _etebase_item_manager_transaction(
        libEtebase,
        invocation,
      );
    case #etebase_item_manager_transaction_deps:
      return _etebase_item_manager_transaction_deps(
        libEtebase,
        invocation,
      );
    case #etebase_item_manager_cache_load:
      return _etebase_item_manager_cache_load(
        libEtebase,
        invocation,
      );
    case #etebase_item_manager_cache_save:
      return _etebase_item_manager_cache_save(
        libEtebase,
        invocation,
      );
    case #etebase_item_manager_cache_save_with_content:
      return _etebase_item_manager_cache_save_with_content(
        libEtebase,
        invocation,
      );
    case #etebase_item_manager_destroy:
      return _etebase_item_manager_destroy(
        libEtebase,
        invocation,
      );
    case #etebase_item_list_response_get_stoken:
      return _etebase_item_list_response_get_stoken(
        libEtebase,
        invocation,
      );
    case #etebase_item_list_response_get_data:
      return _etebase_item_list_response_get_data(
        libEtebase,
        invocation,
      );
    case #etebase_item_list_response_get_data_length:
      return _etebase_item_list_response_get_data_length(
        libEtebase,
        invocation,
      );
    case #etebase_item_list_response_is_done:
      return _etebase_item_list_response_is_done(
        libEtebase,
        invocation,
      );
    case #etebase_item_list_response_destroy:
      return _etebase_item_list_response_destroy(
        libEtebase,
        invocation,
      );
    case #etebase_item_clone:
      return _etebase_item_clone(
        libEtebase,
        invocation,
      );
    case #etebase_item_verify:
      return _etebase_item_verify(
        libEtebase,
        invocation,
      );
    case #etebase_item_set_meta:
      return _etebase_item_set_meta(
        libEtebase,
        invocation,
      );
    case #etebase_item_get_meta:
      return _etebase_item_get_meta(
        libEtebase,
        invocation,
      );
    case #etebase_item_set_meta_raw:
      return _etebase_item_set_meta_raw(
        libEtebase,
        invocation,
      );
    case #etebase_item_get_meta_raw:
      return _etebase_item_get_meta_raw(
        libEtebase,
        invocation,
      );
    case #etebase_item_set_content:
      return _etebase_item_set_content(
        libEtebase,
        invocation,
      );
    case #etebase_item_get_content:
      return _etebase_item_get_content(
        libEtebase,
        invocation,
      );
    case #etebase_item_delete:
      return _etebase_item_delete(
        libEtebase,
        invocation,
      );
    case #etebase_item_is_deleted:
      return _etebase_item_is_deleted(
        libEtebase,
        invocation,
      );
    case #etebase_item_get_uid:
      return _etebase_item_get_uid(
        libEtebase,
        invocation,
      );
    case #etebase_item_get_etag:
      return _etebase_item_get_etag(
        libEtebase,
        invocation,
      );
    case #etebase_item_destroy:
      return _etebase_item_destroy(
        libEtebase,
        invocation,
      );
    case #etebase_fs_cache_new:
      return _etebase_fs_cache_new(
        libEtebase,
        invocation,
      );
    case #etebase_fs_cache_clear_user:
      return _etebase_fs_cache_clear_user(
        libEtebase,
        invocation,
      );
    case #etebase_fs_cache_save_account:
      return _etebase_fs_cache_save_account(
        libEtebase,
        invocation,
      );
    case #etebase_fs_cache_load_account:
      return _etebase_fs_cache_load_account(
        libEtebase,
        invocation,
      );
    case #etebase_fs_cache_save_stoken:
      return _etebase_fs_cache_save_stoken(
        libEtebase,
        invocation,
      );
    case #etebase_fs_cache_load_stoken:
      return _etebase_fs_cache_load_stoken(
        libEtebase,
        invocation,
      );
    case #etebase_fs_cache_collection_save_stoken:
      return _etebase_fs_cache_collection_save_stoken(
        libEtebase,
        invocation,
      );
    case #etebase_fs_cache_collection_load_stoken:
      return _etebase_fs_cache_collection_load_stoken(
        libEtebase,
        invocation,
      );
    case #etebase_fs_cache_collection_set:
      return _etebase_fs_cache_collection_set(
        libEtebase,
        invocation,
      );
    case #etebase_fs_cache_collection_unset:
      return _etebase_fs_cache_collection_unset(
        libEtebase,
        invocation,
      );
    case #etebase_fs_cache_collection_get:
      return _etebase_fs_cache_collection_get(
        libEtebase,
        invocation,
      );
    case #etebase_fs_cache_item_set:
      return _etebase_fs_cache_item_set(
        libEtebase,
        invocation,
      );
    case #etebase_fs_cache_item_unset:
      return _etebase_fs_cache_item_unset(
        libEtebase,
        invocation,
      );
    case #etebase_fs_cache_item_get:
      return _etebase_fs_cache_item_get(
        libEtebase,
        invocation,
      );
    case #etebase_fs_cache_destroy:
      return _etebase_fs_cache_destroy(
        libEtebase,
        invocation,
      );
    case #etebase_fetch_options_new:
      return _etebase_fetch_options_new(
        libEtebase,
        invocation,
      );
    case #etebase_fetch_options_set_limit:
      return _etebase_fetch_options_set_limit(
        libEtebase,
        invocation,
      );
    case #etebase_fetch_options_set_prefetch:
      return _etebase_fetch_options_set_prefetch(
        libEtebase,
        invocation,
      );
    case #etebase_fetch_options_set_with_collection:
      return _etebase_fetch_options_set_with_collection(
        libEtebase,
        invocation,
      );
    case #etebase_fetch_options_set_iterator:
      return _etebase_fetch_options_set_iterator(
        libEtebase,
        invocation,
      );
    case #etebase_fetch_options_set_stoken:
      return _etebase_fetch_options_set_stoken(
        libEtebase,
        invocation,
      );
    case #etebase_fetch_options_destroy:
      return _etebase_fetch_options_destroy(
        libEtebase,
        invocation,
      );
    case #etebase_collection_member_manager_list:
      return _etebase_collection_member_manager_list(
        libEtebase,
        invocation,
      );
    case #etebase_collection_member_manager_remove:
      return _etebase_collection_member_manager_remove(
        libEtebase,
        invocation,
      );
    case #etebase_collection_member_manager_leave:
      return _etebase_collection_member_manager_leave(
        libEtebase,
        invocation,
      );
    case #etebase_collection_member_manager_modify_access_level:
      return _etebase_collection_member_manager_modify_access_level(
        libEtebase,
        invocation,
      );
    case #etebase_collection_member_manager_destroy:
      return _etebase_collection_member_manager_destroy(
        libEtebase,
        invocation,
      );
    case #etebase_collection_member_clone:
      return _etebase_collection_member_clone(
        libEtebase,
        invocation,
      );
    case #etebase_collection_member_get_username:
      return _etebase_collection_member_get_username(
        libEtebase,
        invocation,
      );
    case #etebase_collection_member_get_access_level:
      return _etebase_collection_member_get_access_level(
        libEtebase,
        invocation,
      );
    case #etebase_collection_member_destroy:
      return _etebase_collection_member_destroy(
        libEtebase,
        invocation,
      );
    case #etebase_collection_manager_fetch:
      return _etebase_collection_manager_fetch(
        libEtebase,
        invocation,
      );
    case #etebase_collection_manager_create:
      return _etebase_collection_manager_create(
        libEtebase,
        invocation,
      );
    case #etebase_collection_manager_create_raw:
      return _etebase_collection_manager_create_raw(
        libEtebase,
        invocation,
      );
    case #etebase_collection_manager_get_item_manager:
      return _etebase_collection_manager_get_item_manager(
        libEtebase,
        invocation,
      );
    case #etebase_collection_manager_list:
      return _etebase_collection_manager_list(
        libEtebase,
        invocation,
      );
    case #etebase_collection_manager_list_multi:
      return _etebase_collection_manager_list_multi(
        libEtebase,
        invocation,
      );
    case #etebase_collection_manager_upload:
      return _etebase_collection_manager_upload(
        libEtebase,
        invocation,
      );
    case #etebase_collection_manager_transaction:
      return _etebase_collection_manager_transaction(
        libEtebase,
        invocation,
      );
    case #etebase_collection_manager_cache_load:
      return _etebase_collection_manager_cache_load(
        libEtebase,
        invocation,
      );
    case #etebase_collection_manager_cache_save:
      return _etebase_collection_manager_cache_save(
        libEtebase,
        invocation,
      );
    case #etebase_collection_manager_cache_save_with_content:
      return _etebase_collection_manager_cache_save_with_content(
        libEtebase,
        invocation,
      );
    case #etebase_collection_manager_get_member_manager:
      return _etebase_collection_manager_get_member_manager(
        libEtebase,
        invocation,
      );
    case #etebase_collection_manager_destroy:
      return _etebase_collection_manager_destroy(
        libEtebase,
        invocation,
      );
    case #etebase_collection_list_response_get_stoken:
      return _etebase_collection_list_response_get_stoken(
        libEtebase,
        invocation,
      );
    case #etebase_collection_list_response_get_data:
      return _etebase_collection_list_response_get_data(
        libEtebase,
        invocation,
      );
    case #etebase_collection_list_response_get_data_length:
      return _etebase_collection_list_response_get_data_length(
        libEtebase,
        invocation,
      );
    case #etebase_collection_list_response_is_done:
      return _etebase_collection_list_response_is_done(
        libEtebase,
        invocation,
      );
    case #etebase_collection_list_response_get_removed_memberships:
      return _etebase_collection_list_response_get_removed_memberships(
        libEtebase,
        invocation,
      );
    case #etebase_collection_list_response_get_removed_memberships_length:
      return _etebase_collection_list_response_get_removed_memberships_length(
        libEtebase,
        invocation,
      );
    case #etebase_collection_list_response_destroy:
      return _etebase_collection_list_response_destroy(
        libEtebase,
        invocation,
      );
    case #etebase_invitation_manager_list_incoming:
      return _etebase_invitation_manager_list_incoming(
        libEtebase,
        invocation,
      );
    case #etebase_invitation_manager_list_outgoing:
      return _etebase_invitation_manager_list_outgoing(
        libEtebase,
        invocation,
      );
    case #etebase_invitation_manager_accept:
      return _etebase_invitation_manager_accept(
        libEtebase,
        invocation,
      );
    case #etebase_invitation_manager_reject:
      return _etebase_invitation_manager_reject(
        libEtebase,
        invocation,
      );
    case #etebase_invitation_manager_fetch_user_profile:
      return _etebase_invitation_manager_fetch_user_profile(
        libEtebase,
        invocation,
      );
    case #etebase_invitation_manager_invite:
      return _etebase_invitation_manager_invite(
        libEtebase,
        invocation,
      );
    case #etebase_invitation_manager_disinvite:
      return _etebase_invitation_manager_disinvite(
        libEtebase,
        invocation,
      );
    case #etebase_invitation_manager_get_pubkey:
      return _etebase_invitation_manager_get_pubkey(
        libEtebase,
        invocation,
      );
    case #etebase_invitation_manager_get_pubkey_size:
      return _etebase_invitation_manager_get_pubkey_size(
        libEtebase,
        invocation,
      );
    case #etebase_invitation_manager_destroy:
      return _etebase_invitation_manager_destroy(
        libEtebase,
        invocation,
      );
    case #etebase_collection_clone:
      return _etebase_collection_clone(
        libEtebase,
        invocation,
      );
    case #etebase_collection_verify:
      return _etebase_collection_verify(
        libEtebase,
        invocation,
      );
    case #etebase_collection_set_meta:
      return _etebase_collection_set_meta(
        libEtebase,
        invocation,
      );
    case #etebase_collection_get_meta:
      return _etebase_collection_get_meta(
        libEtebase,
        invocation,
      );
    case #etebase_collection_set_meta_raw:
      return _etebase_collection_set_meta_raw(
        libEtebase,
        invocation,
      );
    case #etebase_collection_get_meta_raw:
      return _etebase_collection_get_meta_raw(
        libEtebase,
        invocation,
      );
    case #etebase_collection_set_content:
      return _etebase_collection_set_content(
        libEtebase,
        invocation,
      );
    case #etebase_collection_get_content:
      return _etebase_collection_get_content(
        libEtebase,
        invocation,
      );
    case #etebase_collection_delete:
      return _etebase_collection_delete(
        libEtebase,
        invocation,
      );
    case #etebase_collection_is_deleted:
      return _etebase_collection_is_deleted(
        libEtebase,
        invocation,
      );
    case #etebase_collection_get_uid:
      return _etebase_collection_get_uid(
        libEtebase,
        invocation,
      );
    case #etebase_collection_get_etag:
      return _etebase_collection_get_etag(
        libEtebase,
        invocation,
      );
    case #etebase_collection_get_stoken:
      return _etebase_collection_get_stoken(
        libEtebase,
        invocation,
      );
    case #etebase_collection_as_item:
      return _etebase_collection_as_item(
        libEtebase,
        invocation,
      );
    case #etebase_collection_get_collection_type:
      return _etebase_collection_get_collection_type(
        libEtebase,
        invocation,
      );
    case #etebase_collection_get_access_level:
      return _etebase_collection_get_access_level(
        libEtebase,
        invocation,
      );
    case #etebase_collection_destroy:
      return _etebase_collection_destroy(
        libEtebase,
        invocation,
      );
    case #etebase_client_new:
      return _etebase_client_new(
        libEtebase,
        invocation,
      );
    case #etebase_client_set_server_url:
      return _etebase_client_set_server_url(
        libEtebase,
        invocation,
      );
    case #etebase_client_check_etebase_server:
      return _etebase_client_check_etebase_server(
        libEtebase,
        invocation,
      );
    case #etebase_client_destroy:
      return _etebase_client_destroy(
        libEtebase,
        invocation,
      );
    case #etebase_account_login:
      return _etebase_account_login(
        libEtebase,
        invocation,
      );
    case #etebase_account_signup:
      return _etebase_account_signup(
        libEtebase,
        invocation,
      );
    case #etebase_account_fetch_token:
      return _etebase_account_fetch_token(
        libEtebase,
        invocation,
      );
    case #etebase_account_fetch_dashboard_url:
      return _etebase_account_fetch_dashboard_url(
        libEtebase,
        invocation,
      );
    case #etebase_account_force_server_url:
      return _etebase_account_force_server_url(
        libEtebase,
        invocation,
      );
    case #etebase_account_change_password:
      return _etebase_account_change_password(
        libEtebase,
        invocation,
      );
    case #etebase_account_logout:
      return _etebase_account_logout(
        libEtebase,
        invocation,
      );
    case #etebase_account_get_collection_manager:
      return _etebase_account_get_collection_manager(
        libEtebase,
        invocation,
      );
    case #etebase_account_get_invitation_manager:
      return _etebase_account_get_invitation_manager(
        libEtebase,
        invocation,
      );
    case #etebase_account_save:
      return _etebase_account_save(
        libEtebase,
        invocation,
      );
    case #etebase_account_restore:
      return _etebase_account_restore(
        libEtebase,
        invocation,
      );
    case #etebase_account_destroy:
      return _etebase_account_destroy(
        libEtebase,
        invocation,
      );
    case #ETEBASE_UTILS_PRETTY_FINGERPRINT_SIZE:
      return _ETEBASE_UTILS_PRETTY_FINGERPRINT_SIZE(
        libEtebase,
        invocation,
      );
    case #etebase_utils_randombytes:
      return _etebase_utils_randombytes(
        libEtebase,
        invocation,
      );
    case #etebase_utils_pretty_fingerprint:
      return _etebase_utils_pretty_fingerprint(
        libEtebase,
        invocation,
      );
    case #etebase_get_default_server_url:
      return _etebase_get_default_server_url(
        libEtebase,
        invocation,
      );
    default:
      throw ArgumentError.value(
        invocation.method,
        'invocation.method',
        'Method does not exist',
      );
  }
}

_i1.MethodResult _etebase_user_profile_get_pubkey(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_user_profile_get_pubkey_size(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_user_profile_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_user_new(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 2, 'Invocation must have exactly 2 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_user_set_username(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_user_get_username(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_user_set_email(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_user_get_email(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_user_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_signed_invitation_clone(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_signed_invitation_get_uid(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_signed_invitation_get_username(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_signed_invitation_get_collection(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_signed_invitation_get_access_level(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_signed_invitation_get_from_username(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_signed_invitation_get_from_pubkey(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_signed_invitation_get_from_pubkey_size(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_signed_invitation_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_removed_collection_get_uid(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_removed_collection_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_invitation_list_response_get_iterator(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_invitation_list_response_get_data(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_invitation_list_response_get_data_length(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_invitation_list_response_is_done(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_invitation_list_response_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_revisions_list_response_get_iterator(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_revisions_list_response_get_data(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_revisions_list_response_get_data_length(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_revisions_list_response_is_done(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_revisions_list_response_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_member_list_response_get_iterator(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_member_list_response_get_data(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_member_list_response_get_data_length(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_member_list_response_is_done(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_member_list_response_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_metadata_new(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_metadata_set_item_type(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_metadata_get_item_type(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_metadata_set_name(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_metadata_get_name(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_metadata_set_mtime(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_metadata_get_mtime(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_metadata_set_description(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_metadata_get_description(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_metadata_set_color(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_metadata_get_color(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_metadata_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_manager_fetch(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 2, 'Invocation must have exactly 2 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_manager_create(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 2, 'Invocation must have exactly 2 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_manager_create_raw(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 2, 'Invocation must have exactly 2 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_manager_list(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_manager_item_revisions(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 2, 'Invocation must have exactly 2 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_manager_fetch_updates(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 2, 'Invocation must have exactly 2 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_manager_fetch_multi(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 2, 'Invocation must have exactly 2 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_manager_batch(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 2, 'Invocation must have exactly 2 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_manager_batch_deps(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 3, 'Invocation must have exactly 3 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_manager_transaction(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 2, 'Invocation must have exactly 2 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_manager_transaction_deps(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 3, 'Invocation must have exactly 3 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_manager_cache_load(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_manager_cache_save(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_manager_cache_save_with_content(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_manager_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_list_response_get_stoken(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_list_response_get_data(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_list_response_get_data_length(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_list_response_is_done(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_list_response_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_clone(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_verify(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_set_meta(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_get_meta(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_set_meta_raw(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_get_meta_raw(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_set_content(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_get_content(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_delete(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_is_deleted(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_get_uid(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_get_etag(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_fs_cache_new(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 2, 'Invocation must have exactly 2 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_fs_cache_clear_user(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_fs_cache_save_account(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 2, 'Invocation must have exactly 2 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_fs_cache_load_account(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 2, 'Invocation must have exactly 2 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_fs_cache_save_stoken(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_fs_cache_load_stoken(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_fs_cache_collection_save_stoken(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 2, 'Invocation must have exactly 2 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_fs_cache_collection_load_stoken(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_fs_cache_collection_set(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 2, 'Invocation must have exactly 2 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_fs_cache_collection_unset(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 2, 'Invocation must have exactly 2 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_fs_cache_collection_get(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 2, 'Invocation must have exactly 2 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_fs_cache_item_set(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 3, 'Invocation must have exactly 3 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_fs_cache_item_unset(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 3, 'Invocation must have exactly 3 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_fs_cache_item_get(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 3, 'Invocation must have exactly 3 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_fs_cache_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_fetch_options_new(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_fetch_options_set_limit(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_fetch_options_set_prefetch(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_fetch_options_set_with_collection(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_fetch_options_set_iterator(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_fetch_options_set_stoken(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_fetch_options_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_member_manager_list(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_member_manager_remove(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_member_manager_leave(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_member_manager_modify_access_level(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 2, 'Invocation must have exactly 2 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_member_manager_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_member_clone(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_member_get_username(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_member_get_access_level(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_member_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_manager_fetch(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 2, 'Invocation must have exactly 2 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_manager_create(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 3, 'Invocation must have exactly 3 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_manager_create_raw(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 3, 'Invocation must have exactly 3 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_manager_get_item_manager(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_manager_list(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 2, 'Invocation must have exactly 2 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_manager_list_multi(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 2, 'Invocation must have exactly 2 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_manager_upload(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 2, 'Invocation must have exactly 2 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_manager_transaction(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 2, 'Invocation must have exactly 2 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_manager_cache_load(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_manager_cache_save(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_manager_cache_save_with_content(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_manager_get_member_manager(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_manager_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_list_response_get_stoken(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_list_response_get_data(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_list_response_get_data_length(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_list_response_is_done(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_list_response_get_removed_memberships(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult
    _etebase_collection_list_response_get_removed_memberships_length(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_list_response_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_invitation_manager_list_incoming(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_invitation_manager_list_outgoing(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_invitation_manager_accept(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_invitation_manager_reject(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_invitation_manager_fetch_user_profile(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_invitation_manager_invite(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 4, 'Invocation must have exactly 4 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_invitation_manager_disinvite(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_invitation_manager_get_pubkey(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_invitation_manager_get_pubkey_size(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_invitation_manager_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_clone(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_verify(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_set_meta(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_get_meta(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_set_meta_raw(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_get_meta_raw(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_set_content(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_get_content(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_delete(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_is_deleted(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_get_uid(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_get_etag(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_get_stoken(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_as_item(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_get_collection_type(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_get_access_level(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_client_new(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 2, 'Invocation must have exactly 2 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_client_set_server_url(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_client_check_etebase_server(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_client_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_account_login(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 3, 'Invocation must have exactly 3 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_account_signup(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 3, 'Invocation must have exactly 3 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_account_fetch_token(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_account_fetch_dashboard_url(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_account_force_server_url(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_account_change_password(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_account_logout(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_account_get_collection_manager(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_account_get_invitation_manager(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_account_save(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_account_restore(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 3, 'Invocation must have exactly 3 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_account_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _ETEBASE_UTILS_PRETTY_FINGERPRINT_SIZE(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_utils_randombytes(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_utils_pretty_fingerprint(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 1, 'Invocation must have exactly 1 parameters');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_get_default_server_url(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  assert(invocation.length == 0, 'Invocation must have exactly 0 parameters');
  throw UnimplementedError();
}
