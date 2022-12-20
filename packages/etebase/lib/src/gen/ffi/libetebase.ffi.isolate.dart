// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// EtebaseIsolateGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, require_trailing_commas, unnecessary_parenthesis, prefer_relative_imports, lines_longer_than_80_chars, prefer_is_empty, constant_identifier_names, avoid_bool_literals_in_conditional_expressions, prefer_const_constructors, unused_element, unused_local_variable, public_member_api_docs
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:ffi' as _i7;
import 'dart:isolate' as _i11;

import 'package:etebase/src/gen/ffi/libetebase.ffi.client.dart' as _i8;
import 'package:etebase/src/gen/ffi/libetebase.ffi.dart' as _i3;
import 'package:etebase/src/isolate/etebase_pool.dart' as _i4;
import 'package:etebase/src/isolate/ffi_helpers.dart' as _i9;
import 'package:etebase/src/isolate/method_invocation.dart' as _i6;
import 'package:etebase/src/isolate/method_result.dart' as _i2;
import 'package:etebase/src/model/etebase_collection_access_level.dart' as _i12;
import 'package:etebase/src/model/etebase_config.dart' as _i5;
import 'package:etebase/src/model/etebase_error_code.dart' as _i13;
import 'package:ffi/ffi.dart' as _i10;
import 'package:ffi/ffi.dart';
import 'package:meta/meta.dart' as _i1;

@_i1.internal
_i2.MethodResult etebaseIsolateMessageHandler(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  try {
    switch (invocation.method) {
      case #etebase_user_profile_get_pubkey:
        return _etebase_user_profile_get_pubkey(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_user_profile_destroy:
        return _etebase_user_profile_destroy(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_signed_invitation_clone:
        return _etebase_signed_invitation_clone(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_signed_invitation_get_uid:
        return _etebase_signed_invitation_get_uid(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_signed_invitation_get_username:
        return _etebase_signed_invitation_get_username(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_signed_invitation_get_collection:
        return _etebase_signed_invitation_get_collection(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_signed_invitation_get_access_level:
        return _etebase_signed_invitation_get_access_level(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_signed_invitation_get_from_username:
        return _etebase_signed_invitation_get_from_username(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_signed_invitation_get_from_pubkey:
        return _etebase_signed_invitation_get_from_pubkey(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_signed_invitation_destroy:
        return _etebase_signed_invitation_destroy(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_removed_collection_get_uid:
        return _etebase_removed_collection_get_uid(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_removed_collection_destroy:
        return _etebase_removed_collection_destroy(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_invitation_list_response_get_iterator:
        return _etebase_invitation_list_response_get_iterator(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_invitation_list_response_get_data:
        return _etebase_invitation_list_response_get_data(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_invitation_list_response_is_done:
        return _etebase_invitation_list_response_is_done(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_invitation_list_response_destroy:
        return _etebase_invitation_list_response_destroy(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_item_revisions_list_response_get_iterator:
        return _etebase_item_revisions_list_response_get_iterator(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_item_revisions_list_response_get_data:
        return _etebase_item_revisions_list_response_get_data(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_item_revisions_list_response_is_done:
        return _etebase_item_revisions_list_response_is_done(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_item_revisions_list_response_destroy:
        return _etebase_item_revisions_list_response_destroy(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_member_list_response_get_iterator:
        return _etebase_member_list_response_get_iterator(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_member_list_response_get_data:
        return _etebase_member_list_response_get_data(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_member_list_response_is_done:
        return _etebase_member_list_response_is_done(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_member_list_response_destroy:
        return _etebase_member_list_response_destroy(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_item_manager_fetch:
        return _etebase_item_manager_fetch(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_item_manager_create:
        return _etebase_item_manager_create(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_item_manager_create_raw:
        return _etebase_item_manager_create_raw(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_item_manager_list:
        return _etebase_item_manager_list(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_item_manager_item_revisions:
        return _etebase_item_manager_item_revisions(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_item_manager_fetch_updates:
        return _etebase_item_manager_fetch_updates(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_item_manager_fetch_multi:
        return _etebase_item_manager_fetch_multi(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_item_manager_batch:
        return _etebase_item_manager_batch(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_item_manager_batch_deps:
        return _etebase_item_manager_batch_deps(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_item_manager_transaction:
        return _etebase_item_manager_transaction(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_item_manager_transaction_deps:
        return _etebase_item_manager_transaction_deps(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_item_manager_cache_load:
        return _etebase_item_manager_cache_load(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_item_manager_cache_save:
        return _etebase_item_manager_cache_save(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_item_manager_cache_save_with_content:
        return _etebase_item_manager_cache_save_with_content(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_item_manager_destroy:
        return _etebase_item_manager_destroy(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_item_list_response_get_stoken:
        return _etebase_item_list_response_get_stoken(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_item_list_response_get_data:
        return _etebase_item_list_response_get_data(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_item_list_response_is_done:
        return _etebase_item_list_response_is_done(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_item_list_response_destroy:
        return _etebase_item_list_response_destroy(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_item_clone:
        return _etebase_item_clone(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_item_verify:
        return _etebase_item_verify(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_item_set_meta:
        return _etebase_item_set_meta(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_item_get_meta:
        return _etebase_item_get_meta(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_item_set_meta_raw:
        return _etebase_item_set_meta_raw(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_item_get_meta_raw:
        return _etebase_item_get_meta_raw(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_item_set_content:
        return _etebase_item_set_content(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_item_get_content:
        return _etebase_item_get_content(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_item_delete:
        return _etebase_item_delete(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_item_is_deleted:
        return _etebase_item_is_deleted(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_item_get_uid:
        return _etebase_item_get_uid(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_item_get_etag:
        return _etebase_item_get_etag(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_item_destroy:
        return _etebase_item_destroy(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_fs_cache_new:
        return _etebase_fs_cache_new(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_fs_cache_clear_user:
        return _etebase_fs_cache_clear_user(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_fs_cache_save_account:
        return _etebase_fs_cache_save_account(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_fs_cache_load_account:
        return _etebase_fs_cache_load_account(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_fs_cache_save_stoken:
        return _etebase_fs_cache_save_stoken(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_fs_cache_load_stoken:
        return _etebase_fs_cache_load_stoken(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_fs_cache_collection_save_stoken:
        return _etebase_fs_cache_collection_save_stoken(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_fs_cache_collection_load_stoken:
        return _etebase_fs_cache_collection_load_stoken(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_fs_cache_collection_set:
        return _etebase_fs_cache_collection_set(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_fs_cache_collection_unset:
        return _etebase_fs_cache_collection_unset(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_fs_cache_collection_get:
        return _etebase_fs_cache_collection_get(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_fs_cache_item_set:
        return _etebase_fs_cache_item_set(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_fs_cache_item_unset:
        return _etebase_fs_cache_item_unset(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_fs_cache_item_get:
        return _etebase_fs_cache_item_get(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_fs_cache_destroy:
        return _etebase_fs_cache_destroy(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_collection_member_manager_list:
        return _etebase_collection_member_manager_list(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_collection_member_manager_remove:
        return _etebase_collection_member_manager_remove(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_collection_member_manager_leave:
        return _etebase_collection_member_manager_leave(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_collection_member_manager_modify_access_level:
        return _etebase_collection_member_manager_modify_access_level(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_collection_member_manager_destroy:
        return _etebase_collection_member_manager_destroy(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_collection_member_clone:
        return _etebase_collection_member_clone(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_collection_member_get_username:
        return _etebase_collection_member_get_username(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_collection_member_get_access_level:
        return _etebase_collection_member_get_access_level(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_collection_member_destroy:
        return _etebase_collection_member_destroy(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_collection_manager_fetch:
        return _etebase_collection_manager_fetch(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_collection_manager_create:
        return _etebase_collection_manager_create(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_collection_manager_create_raw:
        return _etebase_collection_manager_create_raw(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_collection_manager_get_item_manager:
        return _etebase_collection_manager_get_item_manager(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_collection_manager_list:
        return _etebase_collection_manager_list(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_collection_manager_list_multi:
        return _etebase_collection_manager_list_multi(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_collection_manager_upload:
        return _etebase_collection_manager_upload(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_collection_manager_transaction:
        return _etebase_collection_manager_transaction(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_collection_manager_cache_load:
        return _etebase_collection_manager_cache_load(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_collection_manager_cache_save:
        return _etebase_collection_manager_cache_save(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_collection_manager_cache_save_with_content:
        return _etebase_collection_manager_cache_save_with_content(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_collection_manager_get_member_manager:
        return _etebase_collection_manager_get_member_manager(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_collection_manager_destroy:
        return _etebase_collection_manager_destroy(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_collection_list_response_get_stoken:
        return _etebase_collection_list_response_get_stoken(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_collection_list_response_get_data:
        return _etebase_collection_list_response_get_data(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_collection_list_response_is_done:
        return _etebase_collection_list_response_is_done(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_collection_list_response_get_removed_memberships:
        return _etebase_collection_list_response_get_removed_memberships(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_collection_list_response_destroy:
        return _etebase_collection_list_response_destroy(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_invitation_manager_list_incoming:
        return _etebase_invitation_manager_list_incoming(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_invitation_manager_list_outgoing:
        return _etebase_invitation_manager_list_outgoing(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_invitation_manager_accept:
        return _etebase_invitation_manager_accept(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_invitation_manager_reject:
        return _etebase_invitation_manager_reject(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_invitation_manager_fetch_user_profile:
        return _etebase_invitation_manager_fetch_user_profile(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_invitation_manager_invite:
        return _etebase_invitation_manager_invite(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_invitation_manager_disinvite:
        return _etebase_invitation_manager_disinvite(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_invitation_manager_get_pubkey:
        return _etebase_invitation_manager_get_pubkey(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_invitation_manager_destroy:
        return _etebase_invitation_manager_destroy(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_collection_clone:
        return _etebase_collection_clone(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_collection_verify:
        return _etebase_collection_verify(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_collection_set_meta:
        return _etebase_collection_set_meta(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_collection_get_meta:
        return _etebase_collection_get_meta(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_collection_set_meta_raw:
        return _etebase_collection_set_meta_raw(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_collection_get_meta_raw:
        return _etebase_collection_get_meta_raw(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_collection_set_content:
        return _etebase_collection_set_content(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_collection_get_content:
        return _etebase_collection_get_content(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_collection_delete:
        return _etebase_collection_delete(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_collection_is_deleted:
        return _etebase_collection_is_deleted(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_collection_get_uid:
        return _etebase_collection_get_uid(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_collection_get_etag:
        return _etebase_collection_get_etag(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_collection_get_stoken:
        return _etebase_collection_get_stoken(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_collection_as_item:
        return _etebase_collection_as_item(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_collection_get_collection_type:
        return _etebase_collection_get_collection_type(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_collection_get_access_level:
        return _etebase_collection_get_access_level(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_collection_destroy:
        return _etebase_collection_destroy(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_client_new:
        return _etebase_client_new(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_client_set_server_url:
        return _etebase_client_set_server_url(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_client_check_etebase_server:
        return _etebase_client_check_etebase_server(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_client_destroy:
        return _etebase_client_destroy(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_account_login:
        return _etebase_account_login(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_account_signup:
        return _etebase_account_signup(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_account_fetch_token:
        return _etebase_account_fetch_token(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_account_fetch_dashboard_url:
        return _etebase_account_fetch_dashboard_url(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_account_force_server_url:
        return _etebase_account_force_server_url(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_account_change_password:
        return _etebase_account_change_password(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_account_logout:
        return _etebase_account_logout(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_account_get_collection_manager:
        return _etebase_account_get_collection_manager(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_account_get_invitation_manager:
        return _etebase_account_get_invitation_manager(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_account_save:
        return _etebase_account_save(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_account_restore:
        return _etebase_account_restore(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_account_destroy:
        return _etebase_account_destroy(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_utils_randombytes:
        return _etebase_utils_randombytes(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_utils_pretty_fingerprint:
        return _etebase_utils_pretty_fingerprint(
          libEtebase,
          pool,
          config,
          invocation,
        );
      case #etebase_get_default_server_url:
        return _etebase_get_default_server_url(
          libEtebase,
          pool,
          config,
          invocation,
        );
      default:
        throw ArgumentError.value(
          invocation.method,
          'invocation.method',
          'Method does not exist',
        );
    }
  } finally {
    pool.releaseScope();
  }
}

_i7.Pointer<_i3.EtebaseUser> _etebaseUserToNative(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i8.EtebaseUser? data,
) {
  if (data == null) {
    return _i7.nullptr;
  }
  final username = data.username.toNativeUtf8(allocator: pool).cast<_i7.Char>();
  final email = data.email.toNativeUtf8(allocator: pool).cast<_i7.Char>();
  final instance = pool.attachScoped(
    libEtebase.etebase_user_new(
      username,
      email,
    ),
    libEtebase.etebase_user_destroy,
  );
  return instance;
}

_i8.EtebaseUser _etebaseUserFromNative(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i7.Pointer<_i3.EtebaseUser> data,
) {
  final instance = pool.attachScoped(
    data,
    libEtebase.etebase_user_destroy,
  );
  final usernameRaw = libEtebase.etebase_user_get_username(instance);
  if (usernameRaw == _i7.nullptr) {
    _i9.FfiHelpers.throwError(libEtebase);
  }
  final username = usernameRaw.cast<_i10.Utf8>().toDartString();
  final emailRaw = libEtebase.etebase_user_get_email(instance);
  if (emailRaw == _i7.nullptr) {
    _i9.FfiHelpers.throwError(libEtebase);
  }
  final email = emailRaw.cast<_i10.Utf8>().toDartString();
  return _i8.EtebaseUser(
    username: username,
    email: email,
  );
}

_i7.Pointer<_i3.EtebaseItemMetadata> _etebaseItemMetadataToNative(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i8.EtebaseItemMetadata? data,
) {
  if (data == null) {
    return _i7.nullptr;
  }
  final instance = pool.attachScoped(
    libEtebase.etebase_item_metadata_new(),
    libEtebase.etebase_item_metadata_destroy,
  );
  if (data.itemType != null) {
    final itemType =
        data.itemType!.toNativeUtf8(allocator: pool).cast<_i7.Char>();
    libEtebase.etebase_item_metadata_set_item_type(
      instance,
      itemType,
    );
  }
  if (data.name != null) {
    final name = data.name!.toNativeUtf8(allocator: pool).cast<_i7.Char>();
    libEtebase.etebase_item_metadata_set_name(
      instance,
      name,
    );
  }
  if (data.mtime != null) {
    final mtime = pool<_i7.Int64>()..value = data.mtime!.millisecondsSinceEpoch;
    libEtebase.etebase_item_metadata_set_mtime(
      instance,
      mtime,
    );
  }
  if (data.description != null) {
    final description =
        data.description!.toNativeUtf8(allocator: pool).cast<_i7.Char>();
    libEtebase.etebase_item_metadata_set_description(
      instance,
      description,
    );
  }
  if (data.color != null) {
    final color = data.color!.toNativeUtf8(allocator: pool).cast<_i7.Char>();
    libEtebase.etebase_item_metadata_set_color(
      instance,
      color,
    );
  }
  return instance;
}

_i8.EtebaseItemMetadata _etebaseItemMetadataFromNative(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i7.Pointer<_i3.EtebaseItemMetadata> data,
) {
  final instance = pool.attachScoped(
    data,
    libEtebase.etebase_item_metadata_destroy,
  );
  final itemTypeRaw = libEtebase.etebase_item_metadata_get_item_type(instance);
  final itemType = itemTypeRaw == _i7.nullptr
      ? null
      : itemTypeRaw.cast<_i10.Utf8>().toDartString();
  final nameRaw = libEtebase.etebase_item_metadata_get_name(instance);
  final name =
      nameRaw == _i7.nullptr ? null : nameRaw.cast<_i10.Utf8>().toDartString();
  final mtimeRaw = libEtebase.etebase_item_metadata_get_mtime(instance);
  final mtime = mtimeRaw == _i7.nullptr
      ? null
      : DateTime.fromMillisecondsSinceEpoch(mtimeRaw.value);
  final descriptionRaw =
      libEtebase.etebase_item_metadata_get_description(instance);
  final description = descriptionRaw == _i7.nullptr
      ? null
      : descriptionRaw.cast<_i10.Utf8>().toDartString();
  final colorRaw = libEtebase.etebase_item_metadata_get_color(instance);
  final color = colorRaw == _i7.nullptr
      ? null
      : colorRaw.cast<_i10.Utf8>().toDartString();
  return _i8.EtebaseItemMetadata(
    itemType: itemType,
    name: name,
    mtime: mtime,
    description: description,
    color: color,
  );
}

_i7.Pointer<_i3.EtebaseFetchOptions> _etebaseFetchOptionsToNative(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i8.EtebaseFetchOptions? data,
) {
  if (data == null) {
    return _i7.nullptr;
  }
  final instance = pool.attachScoped(
    libEtebase.etebase_fetch_options_new(),
    libEtebase.etebase_fetch_options_destroy,
  );
  if (data.limit != null) {
    final limit = data.limit!;
    libEtebase.etebase_fetch_options_set_limit(
      instance,
      limit,
    );
  }
  if (data.prefetch != null) {
    final prefetch = data.prefetch!.index;
    libEtebase.etebase_fetch_options_set_prefetch(
      instance,
      prefetch,
    );
  }
  if (data.withCollection != null) {
    final withCollection = data.withCollection!;
    libEtebase.etebase_fetch_options_set_with_collection(
      instance,
      withCollection,
    );
  }
  if (data.iterator != null) {
    final iterator =
        data.iterator!.toNativeUtf8(allocator: pool).cast<_i7.Char>();
    libEtebase.etebase_fetch_options_set_iterator(
      instance,
      iterator,
    );
  }
  if (data.stoken != null) {
    final stoken = data.stoken!.toNativeUtf8(allocator: pool).cast<_i7.Char>();
    libEtebase.etebase_fetch_options_set_stoken(
      instance,
      stoken,
    );
  }
  return instance;
}

_i8.EtebaseFetchOptions _etebaseFetchOptionsFromNative(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i7.Pointer<_i3.EtebaseFetchOptions> data,
) {
  final instance = pool.attachScoped(
    data,
    libEtebase.etebase_fetch_options_destroy,
  );
  return _i8.EtebaseFetchOptions();
}

_i2.MethodResult _etebase_user_profile_get_pubkey(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseUserProfile>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_user_profile_get_pubkey(this_);
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<_i11.TransferableTypedData>(
    invocation.id,
    _i11.TransferableTypedData.fromList([
      result
          .cast<_i7.Uint8>()
          .asTypedList(libEtebase.etebase_user_profile_get_pubkey_size(this_))
    ]),
  );
}

_i2.MethodResult _etebase_user_profile_destroy(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseUserProfile>.fromAddress(
      (invocation.arguments[0] as int));
  pool.freeGlobal(this_);
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_signed_invitation_clone(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseSignedInvitation>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_signed_invitation_clone(this_);
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<int>(
    invocation.id,
    pool
        .attachGlobal(
          result,
          libEtebase.etebase_signed_invitation_destroy,
        )
        .address,
  );
}

_i2.MethodResult _etebase_signed_invitation_get_uid(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseSignedInvitation>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_signed_invitation_get_uid(this_);
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<String>(
    invocation.id,
    result.cast<_i10.Utf8>().toDartString(),
  );
}

_i2.MethodResult _etebase_signed_invitation_get_username(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseSignedInvitation>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_signed_invitation_get_username(this_);
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<String>(
    invocation.id,
    result.cast<_i10.Utf8>().toDartString(),
  );
}

_i2.MethodResult _etebase_signed_invitation_get_collection(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseSignedInvitation>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_signed_invitation_get_collection(this_);
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<String>(
    invocation.id,
    result.cast<_i10.Utf8>().toDartString(),
  );
}

_i2.MethodResult _etebase_signed_invitation_get_access_level(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseSignedInvitation>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_signed_invitation_get_access_level(this_);
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<_i12.EtebaseCollectionAccessLevel>(
    invocation.id,
    _i12.EtebaseCollectionAccessLevel.values[result],
  );
}

_i2.MethodResult _etebase_signed_invitation_get_from_username(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseSignedInvitation>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_signed_invitation_get_from_username(this_);
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<String>(
    invocation.id,
    result.cast<_i10.Utf8>().toDartString(),
  );
}

_i2.MethodResult _etebase_signed_invitation_get_from_pubkey(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseSignedInvitation>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_signed_invitation_get_from_pubkey(this_);
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<_i11.TransferableTypedData>(
    invocation.id,
    _i11.TransferableTypedData.fromList([
      result.cast<_i7.Uint8>().asTypedList(
          libEtebase.etebase_signed_invitation_get_from_pubkey_size(this_))
    ]),
  );
}

_i2.MethodResult _etebase_signed_invitation_destroy(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseSignedInvitation>.fromAddress(
      (invocation.arguments[0] as int));
  pool.freeGlobal(this_);
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_removed_collection_get_uid(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseRemovedCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_removed_collection_get_uid(this_);
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<String>(
    invocation.id,
    result.cast<_i10.Utf8>().toDartString(),
  );
}

_i2.MethodResult _etebase_removed_collection_destroy(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseRemovedCollection>.fromAddress(
      (invocation.arguments[0] as int));
  pool.freeGlobal(this_);
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_invitation_list_response_get_iterator(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseInvitationListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  final result =
      libEtebase.etebase_invitation_list_response_get_iterator(this_);
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<String>(
    invocation.id,
    result.cast<_i10.Utf8>().toDartString(),
  );
}

_i2.MethodResult _etebase_invitation_list_response_get_data(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseInvitationListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  final dataSize =
      libEtebase.etebase_invitation_list_response_get_data_length(this_);
  final data = pool<_i7.Pointer<_i3.EtebaseSignedInvitation>>(dataSize);
  final result = libEtebase.etebase_invitation_list_response_get_data(
    this_,
    data,
  );
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<List<int>>(
    invocation.id,
    _i9.FfiHelpers.extractPointerList(
      data,
      dataSize,
      (p) => p.address,
    ),
  );
}

_i2.MethodResult _etebase_invitation_list_response_is_done(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseInvitationListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_invitation_list_response_is_done(this_);
  return _i2.MethodResult.successTyped<bool>(
    invocation.id,
    result,
  );
}

_i2.MethodResult _etebase_invitation_list_response_destroy(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseInvitationListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  pool.freeGlobal(this_);
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_item_revisions_list_response_get_iterator(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseItemRevisionsListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  final result =
      libEtebase.etebase_item_revisions_list_response_get_iterator(this_);
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<String>(
    invocation.id,
    result.cast<_i10.Utf8>().toDartString(),
  );
}

_i2.MethodResult _etebase_item_revisions_list_response_get_data(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseItemRevisionsListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  final dataSize =
      libEtebase.etebase_item_revisions_list_response_get_data_length(this_);
  final data = pool<_i7.Pointer<_i3.EtebaseItem>>(dataSize);
  final result = libEtebase.etebase_item_revisions_list_response_get_data(
    this_,
    data,
  );
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<List<int>>(
    invocation.id,
    _i9.FfiHelpers.extractPointerList(
      data,
      dataSize,
      (p) => p.address,
    ),
  );
}

_i2.MethodResult _etebase_item_revisions_list_response_is_done(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseItemRevisionsListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_item_revisions_list_response_is_done(this_);
  return _i2.MethodResult.successTyped<bool>(
    invocation.id,
    result,
  );
}

_i2.MethodResult _etebase_item_revisions_list_response_destroy(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseItemRevisionsListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  pool.freeGlobal(this_);
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_member_list_response_get_iterator(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseMemberListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_member_list_response_get_iterator(this_);
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<String>(
    invocation.id,
    result.cast<_i10.Utf8>().toDartString(),
  );
}

_i2.MethodResult _etebase_member_list_response_get_data(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseMemberListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  final dataSize =
      libEtebase.etebase_member_list_response_get_data_length(this_);
  final data = pool<_i7.Pointer<_i3.EtebaseCollectionMember>>(dataSize);
  final result = libEtebase.etebase_member_list_response_get_data(
    this_,
    data,
  );
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<List<int>>(
    invocation.id,
    _i9.FfiHelpers.extractPointerList(
      data,
      dataSize,
      (p) => p.address,
    ),
  );
}

_i2.MethodResult _etebase_member_list_response_is_done(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseMemberListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_member_list_response_is_done(this_);
  return _i2.MethodResult.successTyped<bool>(
    invocation.id,
    result,
  );
}

_i2.MethodResult _etebase_member_list_response_destroy(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseMemberListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  pool.freeGlobal(this_);
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_item_manager_fetch(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is String,
      'Parameter itemUid must be of type String');
  assert(invocation.arguments[2] is _i8.EtebaseFetchOptions?,
      'Parameter fetchOptions must be of type EtebaseFetchOptions?');
  final this_ = _i7.Pointer<_i3.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final itemUid = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: pool)
      .cast<_i7.Char>();
  final fetchOptions = _etebaseFetchOptionsToNative(
    libEtebase,
    pool,
    (invocation.arguments[2] as _i8.EtebaseFetchOptions?),
  );
  final result = libEtebase.etebase_item_manager_fetch(
    this_,
    itemUid,
    fetchOptions,
  );
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<int>(
    invocation.id,
    pool
        .attachGlobal(
          result,
          libEtebase.etebase_item_destroy,
        )
        .address,
  );
}

_i2.MethodResult _etebase_item_manager_create(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is _i8.EtebaseItemMetadata,
      'Parameter meta must be of type EtebaseItemMetadata');
  assert(invocation.arguments[2] is _i11.TransferableTypedData,
      'Parameter content must be of type TransferableTypedData');
  final this_ = _i7.Pointer<_i3.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final meta = _etebaseItemMetadataToNative(
    libEtebase,
    pool,
    (invocation.arguments[1] as _i8.EtebaseItemMetadata),
  );
  final content_buffer = (invocation.arguments[2] as _i11.TransferableTypedData)
      .materialize()
      .asUint8List();
  final contentSize = content_buffer.length;
  final content = pool<_i7.Uint8>(contentSize);
  content.asTypedList(contentSize).setAll(
        0,
        content_buffer,
      );
  final result = libEtebase.etebase_item_manager_create(
    this_,
    meta,
    content.cast(),
    contentSize,
  );
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<int>(
    invocation.id,
    pool
        .attachGlobal(
          result,
          libEtebase.etebase_item_destroy,
        )
        .address,
  );
}

_i2.MethodResult _etebase_item_manager_create_raw(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is _i11.TransferableTypedData,
      'Parameter meta must be of type TransferableTypedData');
  assert(invocation.arguments[2] is _i11.TransferableTypedData,
      'Parameter content must be of type TransferableTypedData');
  final this_ = _i7.Pointer<_i3.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final meta_buffer = (invocation.arguments[1] as _i11.TransferableTypedData)
      .materialize()
      .asUint8List();
  final metaSize = meta_buffer.length;
  final meta = pool<_i7.Uint8>(metaSize);
  meta.asTypedList(metaSize).setAll(
        0,
        meta_buffer,
      );
  final content_buffer = (invocation.arguments[2] as _i11.TransferableTypedData)
      .materialize()
      .asUint8List();
  final contentSize = content_buffer.length;
  final content = pool<_i7.Uint8>(contentSize);
  content.asTypedList(contentSize).setAll(
        0,
        content_buffer,
      );
  final result = libEtebase.etebase_item_manager_create_raw(
    this_,
    meta.cast(),
    metaSize,
    content.cast(),
    contentSize,
  );
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<int>(
    invocation.id,
    pool
        .attachGlobal(
          result,
          libEtebase.etebase_item_destroy,
        )
        .address,
  );
}

_i2.MethodResult _etebase_item_manager_list(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is _i8.EtebaseFetchOptions?,
      'Parameter fetchOptions must be of type EtebaseFetchOptions?');
  final this_ = _i7.Pointer<_i3.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final fetchOptions = _etebaseFetchOptionsToNative(
    libEtebase,
    pool,
    (invocation.arguments[1] as _i8.EtebaseFetchOptions?),
  );
  final result = libEtebase.etebase_item_manager_list(
    this_,
    fetchOptions,
  );
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<int>(
    invocation.id,
    pool
        .attachGlobal(
          result,
          libEtebase.etebase_item_list_response_destroy,
        )
        .address,
  );
}

_i2.MethodResult _etebase_item_manager_item_revisions(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is int, 'Parameter item must be of type int');
  assert(invocation.arguments[2] is _i8.EtebaseFetchOptions?,
      'Parameter fetchOptions must be of type EtebaseFetchOptions?');
  final this_ = _i7.Pointer<_i3.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final item = _i7.Pointer<_i3.EtebaseItem>.fromAddress(
      (invocation.arguments[1] as int));
  final fetchOptions = _etebaseFetchOptionsToNative(
    libEtebase,
    pool,
    (invocation.arguments[2] as _i8.EtebaseFetchOptions?),
  );
  final result = libEtebase.etebase_item_manager_item_revisions(
    this_,
    item,
    fetchOptions,
  );
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<int>(
    invocation.id,
    pool
        .attachGlobal(
          result,
          libEtebase.etebase_item_revisions_list_response_destroy,
        )
        .address,
  );
}

_i2.MethodResult _etebase_item_manager_fetch_updates(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is List<int>,
      'Parameter items must be of type List<int>');
  assert(invocation.arguments[2] is _i8.EtebaseFetchOptions?,
      'Parameter fetchOptions must be of type EtebaseFetchOptions?');
  final this_ = _i7.Pointer<_i3.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final itemsSize = (invocation.arguments[1] as List<int>).length;
  final items = pool<_i7.Pointer<_i3.EtebaseItem>>(itemsSize);
  _i9.FfiHelpers.assignPointerList(
    items,
    (invocation.arguments[1] as List<int>),
    _i7.Pointer<_i3.EtebaseItem>.fromAddress,
  );
  final fetchOptions = _etebaseFetchOptionsToNative(
    libEtebase,
    pool,
    (invocation.arguments[2] as _i8.EtebaseFetchOptions?),
  );
  final result = libEtebase.etebase_item_manager_fetch_updates(
    this_,
    items,
    itemsSize,
    fetchOptions,
  );
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<int>(
    invocation.id,
    pool
        .attachGlobal(
          result,
          libEtebase.etebase_item_list_response_destroy,
        )
        .address,
  );
}

_i2.MethodResult _etebase_item_manager_fetch_multi(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is List<String>,
      'Parameter items must be of type List<String>');
  assert(invocation.arguments[2] is _i8.EtebaseFetchOptions?,
      'Parameter fetchOptions must be of type EtebaseFetchOptions?');
  final this_ = _i7.Pointer<_i3.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final itemsSize = (invocation.arguments[1] as List<String>).length;
  final items = pool<_i7.Pointer<_i7.Char>>(itemsSize);
  _i9.FfiHelpers.assignPointerList(
    items,
    (invocation.arguments[1] as List<String>),
    (s) => s.toNativeUtf8(allocator: pool).cast<_i7.Char>(),
  );
  final fetchOptions = _etebaseFetchOptionsToNative(
    libEtebase,
    pool,
    (invocation.arguments[2] as _i8.EtebaseFetchOptions?),
  );
  final result = libEtebase.etebase_item_manager_fetch_multi(
    this_,
    items,
    itemsSize,
    fetchOptions,
  );
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<int>(
    invocation.id,
    pool
        .attachGlobal(
          result,
          libEtebase.etebase_item_list_response_destroy,
        )
        .address,
  );
}

_i2.MethodResult _etebase_item_manager_batch(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is List<int>,
      'Parameter items must be of type List<int>');
  assert(invocation.arguments[2] is _i8.EtebaseFetchOptions?,
      'Parameter fetchOptions must be of type EtebaseFetchOptions?');
  final this_ = _i7.Pointer<_i3.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final itemsSize = (invocation.arguments[1] as List<int>).length;
  final items = pool<_i7.Pointer<_i3.EtebaseItem>>(itemsSize);
  _i9.FfiHelpers.assignPointerList(
    items,
    (invocation.arguments[1] as List<int>),
    _i7.Pointer<_i3.EtebaseItem>.fromAddress,
  );
  final fetchOptions = _etebaseFetchOptionsToNative(
    libEtebase,
    pool,
    (invocation.arguments[2] as _i8.EtebaseFetchOptions?),
  );
  final result = libEtebase.etebase_item_manager_batch(
    this_,
    items,
    itemsSize,
    fetchOptions,
  );
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_item_manager_batch_deps(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 4,
      'Invocation must have exactly 4 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is List<int>,
      'Parameter items must be of type List<int>');
  assert(invocation.arguments[2] is List<int>,
      'Parameter deps must be of type List<int>');
  assert(invocation.arguments[3] is _i8.EtebaseFetchOptions?,
      'Parameter fetchOptions must be of type EtebaseFetchOptions?');
  final this_ = _i7.Pointer<_i3.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final itemsSize = (invocation.arguments[1] as List<int>).length;
  final items = pool<_i7.Pointer<_i3.EtebaseItem>>(itemsSize);
  _i9.FfiHelpers.assignPointerList(
    items,
    (invocation.arguments[1] as List<int>),
    _i7.Pointer<_i3.EtebaseItem>.fromAddress,
  );
  final depsSize = (invocation.arguments[2] as List<int>).length;
  final deps = pool<_i7.Pointer<_i3.EtebaseItem>>(depsSize);
  _i9.FfiHelpers.assignPointerList(
    deps,
    (invocation.arguments[2] as List<int>),
    _i7.Pointer<_i3.EtebaseItem>.fromAddress,
  );
  final fetchOptions = _etebaseFetchOptionsToNative(
    libEtebase,
    pool,
    (invocation.arguments[3] as _i8.EtebaseFetchOptions?),
  );
  final result = libEtebase.etebase_item_manager_batch_deps(
    this_,
    items,
    itemsSize,
    deps,
    depsSize,
    fetchOptions,
  );
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_item_manager_transaction(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is List<int>,
      'Parameter items must be of type List<int>');
  assert(invocation.arguments[2] is _i8.EtebaseFetchOptions?,
      'Parameter fetchOptions must be of type EtebaseFetchOptions?');
  final this_ = _i7.Pointer<_i3.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final itemsSize = (invocation.arguments[1] as List<int>).length;
  final items = pool<_i7.Pointer<_i3.EtebaseItem>>(itemsSize);
  _i9.FfiHelpers.assignPointerList(
    items,
    (invocation.arguments[1] as List<int>),
    _i7.Pointer<_i3.EtebaseItem>.fromAddress,
  );
  final fetchOptions = _etebaseFetchOptionsToNative(
    libEtebase,
    pool,
    (invocation.arguments[2] as _i8.EtebaseFetchOptions?),
  );
  final result = libEtebase.etebase_item_manager_transaction(
    this_,
    items,
    itemsSize,
    fetchOptions,
  );
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_item_manager_transaction_deps(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 4,
      'Invocation must have exactly 4 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is List<int>,
      'Parameter items must be of type List<int>');
  assert(invocation.arguments[2] is List<int>,
      'Parameter deps must be of type List<int>');
  assert(invocation.arguments[3] is _i8.EtebaseFetchOptions?,
      'Parameter fetchOptions must be of type EtebaseFetchOptions?');
  final this_ = _i7.Pointer<_i3.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final itemsSize = (invocation.arguments[1] as List<int>).length;
  final items = pool<_i7.Pointer<_i3.EtebaseItem>>(itemsSize);
  _i9.FfiHelpers.assignPointerList(
    items,
    (invocation.arguments[1] as List<int>),
    _i7.Pointer<_i3.EtebaseItem>.fromAddress,
  );
  final depsSize = (invocation.arguments[2] as List<int>).length;
  final deps = pool<_i7.Pointer<_i3.EtebaseItem>>(depsSize);
  _i9.FfiHelpers.assignPointerList(
    deps,
    (invocation.arguments[2] as List<int>),
    _i7.Pointer<_i3.EtebaseItem>.fromAddress,
  );
  final fetchOptions = _etebaseFetchOptionsToNative(
    libEtebase,
    pool,
    (invocation.arguments[3] as _i8.EtebaseFetchOptions?),
  );
  final result = libEtebase.etebase_item_manager_transaction_deps(
    this_,
    items,
    itemsSize,
    deps,
    depsSize,
    fetchOptions,
  );
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_item_manager_cache_load(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is _i11.TransferableTypedData,
      'Parameter cached must be of type TransferableTypedData');
  final this_ = _i7.Pointer<_i3.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final cached_buffer = (invocation.arguments[1] as _i11.TransferableTypedData)
      .materialize()
      .asUint8List();
  final cachedSize = cached_buffer.length;
  final cached = pool<_i7.Uint8>(cachedSize);
  cached.asTypedList(cachedSize).setAll(
        0,
        cached_buffer,
      );
  final result = libEtebase.etebase_item_manager_cache_load(
    this_,
    cached.cast(),
    cachedSize,
  );
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<int>(
    invocation.id,
    pool
        .attachGlobal(
          result,
          libEtebase.etebase_item_destroy,
        )
        .address,
  );
}

_i2.MethodResult _etebase_item_manager_cache_save(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is int, 'Parameter item must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final item = _i7.Pointer<_i3.EtebaseItem>.fromAddress(
      (invocation.arguments[1] as int));
  final retSize = pool<_i7.UintPtr>()..value = 0;
  final result = libEtebase.etebase_item_manager_cache_save(
    this_,
    item,
    retSize,
  );
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<_i11.TransferableTypedData>(
    invocation.id,
    _i11.TransferableTypedData.fromList([
      pool.attachScoped(result).cast<_i7.Uint8>().asTypedList(retSize.value)
    ]),
  );
}

_i2.MethodResult _etebase_item_manager_cache_save_with_content(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is int, 'Parameter item must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final item = _i7.Pointer<_i3.EtebaseItem>.fromAddress(
      (invocation.arguments[1] as int));
  final retSize = pool<_i7.UintPtr>()..value = 0;
  final result = libEtebase.etebase_item_manager_cache_save_with_content(
    this_,
    item,
    retSize,
  );
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<_i11.TransferableTypedData>(
    invocation.id,
    _i11.TransferableTypedData.fromList([
      pool.attachScoped(result).cast<_i7.Uint8>().asTypedList(retSize.value)
    ]),
  );
}

_i2.MethodResult _etebase_item_manager_destroy(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  pool.freeGlobal(this_);
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_item_list_response_get_stoken(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseItemListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_item_list_response_get_stoken(this_);
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<String>(
    invocation.id,
    result.cast<_i10.Utf8>().toDartString(),
  );
}

_i2.MethodResult _etebase_item_list_response_get_data(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseItemListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  final dataSize = libEtebase.etebase_item_list_response_get_data_length(this_);
  final data = pool<_i7.Pointer<_i3.EtebaseItem>>(dataSize);
  final result = libEtebase.etebase_item_list_response_get_data(
    this_,
    data,
  );
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<List<int>>(
    invocation.id,
    _i9.FfiHelpers.extractPointerList(
      data,
      dataSize,
      (p) => p.address,
    ),
  );
}

_i2.MethodResult _etebase_item_list_response_is_done(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseItemListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_item_list_response_is_done(this_);
  return _i2.MethodResult.successTyped<bool>(
    invocation.id,
    result,
  );
}

_i2.MethodResult _etebase_item_list_response_destroy(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseItemListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  pool.freeGlobal(this_);
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_item_clone(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_item_clone(this_);
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<int>(
    invocation.id,
    pool
        .attachGlobal(
          result,
          libEtebase.etebase_item_destroy,
        )
        .address,
  );
}

_i2.MethodResult _etebase_item_verify(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_item_verify(this_);
  return _i2.MethodResult.successTyped<bool>(
    invocation.id,
    result,
  );
}

_i2.MethodResult _etebase_item_set_meta(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is _i8.EtebaseItemMetadata,
      'Parameter meta must be of type EtebaseItemMetadata');
  final this_ = _i7.Pointer<_i3.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  final meta = _etebaseItemMetadataToNative(
    libEtebase,
    pool,
    (invocation.arguments[1] as _i8.EtebaseItemMetadata),
  );
  final result = libEtebase.etebase_item_set_meta(
    this_,
    meta,
  );
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_item_get_meta(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_item_get_meta(this_);
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<_i8.EtebaseItemMetadata>(
    invocation.id,
    _etebaseItemMetadataFromNative(
      libEtebase,
      pool,
      result,
    ),
  );
}

_i2.MethodResult _etebase_item_set_meta_raw(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is _i11.TransferableTypedData,
      'Parameter meta must be of type TransferableTypedData');
  final this_ = _i7.Pointer<_i3.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  final meta_buffer = (invocation.arguments[1] as _i11.TransferableTypedData)
      .materialize()
      .asUint8List();
  final metaSize = meta_buffer.length;
  final meta = pool<_i7.Uint8>(metaSize);
  meta.asTypedList(metaSize).setAll(
        0,
        meta_buffer,
      );
  final result = libEtebase.etebase_item_set_meta_raw(
    this_,
    meta.cast(),
    metaSize,
  );
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_item_get_meta_raw(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation, {
  int? reinvokedWithSize,
}) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is int?,
      'Parameter sizeHint must be of type int?');
  final this_ = _i7.Pointer<_i3.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  final bufSize = reinvokedWithSize ??
      (invocation.arguments[1] as int?) ??
      config.defaultContentBufferSize;
  final buf = pool<_i7.Uint8>(bufSize);
  final result = libEtebase.etebase_item_get_meta_raw(
    this_,
    buf.cast(),
    bufSize,
  );
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  } else if (result <= bufSize) {
    return _i2.MethodResult.successTyped<_i11.TransferableTypedData>(
      invocation.id,
      _i11.TransferableTypedData.fromList(
          [buf.cast<_i7.Uint8>().asTypedList(result)]),
    );
  } else if (reinvokedWithSize != null) {
    return _i2.MethodResult.failure(
      invocation.id,
      _i13.EtebaseErrorCode.generic,
      'output size of etebase_item_get_meta_raw changed during invocation',
    );
  } else {
    return _etebase_item_get_meta_raw(
      libEtebase,
      pool,
      config,
      invocation,
      reinvokedWithSize: result,
    );
  }
}

_i2.MethodResult _etebase_item_set_content(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is _i11.TransferableTypedData,
      'Parameter content must be of type TransferableTypedData');
  final this_ = _i7.Pointer<_i3.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  final content_buffer = (invocation.arguments[1] as _i11.TransferableTypedData)
      .materialize()
      .asUint8List();
  final contentSize = content_buffer.length;
  final content = pool<_i7.Uint8>(contentSize);
  content.asTypedList(contentSize).setAll(
        0,
        content_buffer,
      );
  final result = libEtebase.etebase_item_set_content(
    this_,
    content.cast(),
    contentSize,
  );
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_item_get_content(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation, {
  int? reinvokedWithSize,
}) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is int?,
      'Parameter sizeHint must be of type int?');
  final this_ = _i7.Pointer<_i3.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  final bufSize = reinvokedWithSize ??
      (invocation.arguments[1] as int?) ??
      config.defaultContentBufferSize;
  final buf = pool<_i7.Uint8>(bufSize);
  final result = libEtebase.etebase_item_get_content(
    this_,
    buf.cast(),
    bufSize,
  );
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  } else if (result <= bufSize) {
    return _i2.MethodResult.successTyped<_i11.TransferableTypedData>(
      invocation.id,
      _i11.TransferableTypedData.fromList(
          [buf.cast<_i7.Uint8>().asTypedList(result)]),
    );
  } else if (reinvokedWithSize != null) {
    return _i2.MethodResult.failure(
      invocation.id,
      _i13.EtebaseErrorCode.generic,
      'output size of etebase_item_get_content changed during invocation',
    );
  } else {
    return _etebase_item_get_content(
      libEtebase,
      pool,
      config,
      invocation,
      reinvokedWithSize: result,
    );
  }
}

_i2.MethodResult _etebase_item_delete(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_item_delete(this_);
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_item_is_deleted(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_item_is_deleted(this_);
  return _i2.MethodResult.successTyped<bool>(
    invocation.id,
    result,
  );
}

_i2.MethodResult _etebase_item_get_uid(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_item_get_uid(this_);
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<String>(
    invocation.id,
    result.cast<_i10.Utf8>().toDartString(),
  );
}

_i2.MethodResult _etebase_item_get_etag(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_item_get_etag(this_);
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<String>(
    invocation.id,
    result.cast<_i10.Utf8>().toDartString(),
  );
}

_i2.MethodResult _etebase_item_destroy(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  pool.freeGlobal(this_);
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_fs_cache_new(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is String,
      'Parameter path must be of type String');
  assert(invocation.arguments[1] is String,
      'Parameter username must be of type String');
  final path = (invocation.arguments[0] as String)
      .toNativeUtf8(allocator: pool)
      .cast<_i7.Char>();
  final username = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: pool)
      .cast<_i7.Char>();
  final result = libEtebase.etebase_fs_cache_new(
    path,
    username,
  );
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<int>(
    invocation.id,
    pool
        .attachGlobal(
          result,
          libEtebase.etebase_fs_cache_destroy,
        )
        .address,
  );
}

_i2.MethodResult _etebase_fs_cache_clear_user(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_fs_cache_clear_user(this_);
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_fs_cache_save_account(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(
      invocation.arguments[1] is int, 'Parameter etebase must be of type int');
  assert(invocation.arguments[2] is _i11.TransferableTypedData?,
      'Parameter encryptionKey must be of type TransferableTypedData?');
  final this_ = _i7.Pointer<_i3.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final etebase = _i7.Pointer<_i3.EtebaseAccount>.fromAddress(
      (invocation.arguments[1] as int));
  final encryptionKey_buffer =
      (invocation.arguments[2] as _i11.TransferableTypedData?)
          ?.materialize()
          .asUint8List();
  final encryptionKeySize = encryptionKey_buffer?.length ?? 0;
  if (encryptionKey_buffer != null && encryptionKeySize != 32) {
    throw ArgumentError(
      'should be 32 bytes long, but has $encryptionKeySize bytes',
      'encryptionKey',
    );
  }
  final encryptionKey = encryptionKey_buffer == null
      ? _i7.nullptr
      : pool<_i7.Uint8>(encryptionKeySize);
  if (encryptionKey_buffer != null) {
    encryptionKey.asTypedList(encryptionKeySize).setAll(
          0,
          encryptionKey_buffer,
        );
  }
  final result = libEtebase.etebase_fs_cache_save_account(
    this_,
    etebase,
    encryptionKey.cast(),
    encryptionKeySize,
  );
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_fs_cache_load_account(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(
      invocation.arguments[1] is int, 'Parameter client must be of type int');
  assert(invocation.arguments[2] is _i11.TransferableTypedData?,
      'Parameter encryptionKey must be of type TransferableTypedData?');
  final this_ = _i7.Pointer<_i3.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final client = _i7.Pointer<_i3.EtebaseClient>.fromAddress(
      (invocation.arguments[1] as int));
  final encryptionKey_buffer =
      (invocation.arguments[2] as _i11.TransferableTypedData?)
          ?.materialize()
          .asUint8List();
  final encryptionKeySize = encryptionKey_buffer?.length ?? 0;
  if (encryptionKey_buffer != null && encryptionKeySize != 32) {
    throw ArgumentError(
      'should be 32 bytes long, but has $encryptionKeySize bytes',
      'encryptionKey',
    );
  }
  final encryptionKey = encryptionKey_buffer == null
      ? _i7.nullptr
      : pool<_i7.Uint8>(encryptionKeySize);
  if (encryptionKey_buffer != null) {
    encryptionKey.asTypedList(encryptionKeySize).setAll(
          0,
          encryptionKey_buffer,
        );
  }
  final result = libEtebase.etebase_fs_cache_load_account(
    this_,
    client,
    encryptionKey.cast(),
    encryptionKeySize,
  );
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<int>(
    invocation.id,
    pool
        .attachGlobal(
          result,
          libEtebase.etebase_account_destroy,
        )
        .address,
  );
}

_i2.MethodResult _etebase_fs_cache_save_stoken(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is String,
      'Parameter stoken must be of type String');
  final this_ = _i7.Pointer<_i3.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final stoken = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: pool)
      .cast<_i7.Char>();
  final result = libEtebase.etebase_fs_cache_save_stoken(
    this_,
    stoken,
  );
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_fs_cache_load_stoken(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_fs_cache_load_stoken(this_);
  return _i2.MethodResult.successTyped<String?>(
    invocation.id,
    result == _i7.nullptr
        ? null
        : pool.attachScoped(result).cast<_i10.Utf8>().toDartString(),
  );
}

_i2.MethodResult _etebase_fs_cache_collection_save_stoken(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is String,
      'Parameter colUid must be of type String');
  assert(invocation.arguments[2] is String,
      'Parameter stoken must be of type String');
  final this_ = _i7.Pointer<_i3.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final colUid = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: pool)
      .cast<_i7.Char>();
  final stoken = (invocation.arguments[2] as String)
      .toNativeUtf8(allocator: pool)
      .cast<_i7.Char>();
  final result = libEtebase.etebase_fs_cache_collection_save_stoken(
    this_,
    colUid,
    stoken,
  );
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_fs_cache_collection_load_stoken(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is String,
      'Parameter colUid must be of type String');
  final this_ = _i7.Pointer<_i3.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final colUid = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: pool)
      .cast<_i7.Char>();
  final result = libEtebase.etebase_fs_cache_collection_load_stoken(
    this_,
    colUid,
  );
  return _i2.MethodResult.successTyped<String?>(
    invocation.id,
    result == _i7.nullptr
        ? null
        : pool.attachScoped(result).cast<_i10.Utf8>().toDartString(),
  );
}

_i2.MethodResult _etebase_fs_cache_collection_set(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(
      invocation.arguments[1] is int, 'Parameter colMgr must be of type int');
  assert(invocation.arguments[2] is int, 'Parameter col must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final colMgr = _i7.Pointer<_i3.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[1] as int));
  final col = _i7.Pointer<_i3.EtebaseCollection>.fromAddress(
      (invocation.arguments[2] as int));
  final result = libEtebase.etebase_fs_cache_collection_set(
    this_,
    colMgr,
    col,
  );
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_fs_cache_collection_unset(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(
      invocation.arguments[1] is int, 'Parameter colMgr must be of type int');
  assert(invocation.arguments[2] is String,
      'Parameter colUid must be of type String');
  final this_ = _i7.Pointer<_i3.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final colMgr = _i7.Pointer<_i3.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[1] as int));
  final colUid = (invocation.arguments[2] as String)
      .toNativeUtf8(allocator: pool)
      .cast<_i7.Char>();
  final result = libEtebase.etebase_fs_cache_collection_unset(
    this_,
    colMgr,
    colUid,
  );
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_fs_cache_collection_get(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(
      invocation.arguments[1] is int, 'Parameter colMgr must be of type int');
  assert(invocation.arguments[2] is String,
      'Parameter colUid must be of type String');
  final this_ = _i7.Pointer<_i3.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final colMgr = _i7.Pointer<_i3.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[1] as int));
  final colUid = (invocation.arguments[2] as String)
      .toNativeUtf8(allocator: pool)
      .cast<_i7.Char>();
  final result = libEtebase.etebase_fs_cache_collection_get(
    this_,
    colMgr,
    colUid,
  );
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<int>(
    invocation.id,
    pool
        .attachGlobal(
          result,
          libEtebase.etebase_collection_destroy,
        )
        .address,
  );
}

_i2.MethodResult _etebase_fs_cache_item_set(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 4,
      'Invocation must have exactly 4 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(
      invocation.arguments[1] is int, 'Parameter itemMgr must be of type int');
  assert(invocation.arguments[2] is String,
      'Parameter colUid must be of type String');
  assert(invocation.arguments[3] is int, 'Parameter item must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final itemMgr = _i7.Pointer<_i3.EtebaseItemManager>.fromAddress(
      (invocation.arguments[1] as int));
  final colUid = (invocation.arguments[2] as String)
      .toNativeUtf8(allocator: pool)
      .cast<_i7.Char>();
  final item = _i7.Pointer<_i3.EtebaseItem>.fromAddress(
      (invocation.arguments[3] as int));
  final result = libEtebase.etebase_fs_cache_item_set(
    this_,
    itemMgr,
    colUid,
    item,
  );
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_fs_cache_item_unset(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 4,
      'Invocation must have exactly 4 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(
      invocation.arguments[1] is int, 'Parameter itemMgr must be of type int');
  assert(invocation.arguments[2] is String,
      'Parameter colUid must be of type String');
  assert(invocation.arguments[3] is String,
      'Parameter itemUid must be of type String');
  final this_ = _i7.Pointer<_i3.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final itemMgr = _i7.Pointer<_i3.EtebaseItemManager>.fromAddress(
      (invocation.arguments[1] as int));
  final colUid = (invocation.arguments[2] as String)
      .toNativeUtf8(allocator: pool)
      .cast<_i7.Char>();
  final itemUid = (invocation.arguments[3] as String)
      .toNativeUtf8(allocator: pool)
      .cast<_i7.Char>();
  final result = libEtebase.etebase_fs_cache_item_unset(
    this_,
    itemMgr,
    colUid,
    itemUid,
  );
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_fs_cache_item_get(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 4,
      'Invocation must have exactly 4 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(
      invocation.arguments[1] is int, 'Parameter itemMgr must be of type int');
  assert(invocation.arguments[2] is String,
      'Parameter colUid must be of type String');
  assert(invocation.arguments[3] is String,
      'Parameter itemUid must be of type String');
  final this_ = _i7.Pointer<_i3.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final itemMgr = _i7.Pointer<_i3.EtebaseItemManager>.fromAddress(
      (invocation.arguments[1] as int));
  final colUid = (invocation.arguments[2] as String)
      .toNativeUtf8(allocator: pool)
      .cast<_i7.Char>();
  final itemUid = (invocation.arguments[3] as String)
      .toNativeUtf8(allocator: pool)
      .cast<_i7.Char>();
  final result = libEtebase.etebase_fs_cache_item_get(
    this_,
    itemMgr,
    colUid,
    itemUid,
  );
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<int>(
    invocation.id,
    pool
        .attachGlobal(
          result,
          libEtebase.etebase_item_destroy,
        )
        .address,
  );
}

_i2.MethodResult _etebase_fs_cache_destroy(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  pool.freeGlobal(this_);
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_collection_member_manager_list(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is _i8.EtebaseFetchOptions?,
      'Parameter fetchOptions must be of type EtebaseFetchOptions?');
  final this_ = _i7.Pointer<_i3.EtebaseCollectionMemberManager>.fromAddress(
      (invocation.arguments[0] as int));
  final fetchOptions = _etebaseFetchOptionsToNative(
    libEtebase,
    pool,
    (invocation.arguments[1] as _i8.EtebaseFetchOptions?),
  );
  final result = libEtebase.etebase_collection_member_manager_list(
    this_,
    fetchOptions,
  );
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<int>(
    invocation.id,
    pool
        .attachGlobal(
          result,
          libEtebase.etebase_member_list_response_destroy,
        )
        .address,
  );
}

_i2.MethodResult _etebase_collection_member_manager_remove(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is String,
      'Parameter username must be of type String');
  final this_ = _i7.Pointer<_i3.EtebaseCollectionMemberManager>.fromAddress(
      (invocation.arguments[0] as int));
  final username = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: pool)
      .cast<_i7.Char>();
  final result = libEtebase.etebase_collection_member_manager_remove(
    this_,
    username,
  );
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_collection_member_manager_leave(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseCollectionMemberManager>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_member_manager_leave(this_);
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_collection_member_manager_modify_access_level(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is String,
      'Parameter username must be of type String');
  assert(invocation.arguments[2] is _i12.EtebaseCollectionAccessLevel,
      'Parameter accessLevel must be of type EtebaseCollectionAccessLevel');
  final this_ = _i7.Pointer<_i3.EtebaseCollectionMemberManager>.fromAddress(
      (invocation.arguments[0] as int));
  final username = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: pool)
      .cast<_i7.Char>();
  final accessLevel =
      (invocation.arguments[2] as _i12.EtebaseCollectionAccessLevel).index;
  final result =
      libEtebase.etebase_collection_member_manager_modify_access_level(
    this_,
    username,
    accessLevel,
  );
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_collection_member_manager_destroy(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseCollectionMemberManager>.fromAddress(
      (invocation.arguments[0] as int));
  pool.freeGlobal(this_);
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_collection_member_clone(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseCollectionMember>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_member_clone(this_);
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<int>(
    invocation.id,
    pool
        .attachGlobal(
          result,
          libEtebase.etebase_collection_member_destroy,
        )
        .address,
  );
}

_i2.MethodResult _etebase_collection_member_get_username(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseCollectionMember>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_member_get_username(this_);
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<String>(
    invocation.id,
    result.cast<_i10.Utf8>().toDartString(),
  );
}

_i2.MethodResult _etebase_collection_member_get_access_level(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseCollectionMember>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_member_get_access_level(this_);
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<_i12.EtebaseCollectionAccessLevel>(
    invocation.id,
    _i12.EtebaseCollectionAccessLevel.values[result],
  );
}

_i2.MethodResult _etebase_collection_member_destroy(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseCollectionMember>.fromAddress(
      (invocation.arguments[0] as int));
  pool.freeGlobal(this_);
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_collection_manager_fetch(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is String,
      'Parameter colUid must be of type String');
  assert(invocation.arguments[2] is _i8.EtebaseFetchOptions?,
      'Parameter fetchOptions must be of type EtebaseFetchOptions?');
  final this_ = _i7.Pointer<_i3.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  final colUid = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: pool)
      .cast<_i7.Char>();
  final fetchOptions = _etebaseFetchOptionsToNative(
    libEtebase,
    pool,
    (invocation.arguments[2] as _i8.EtebaseFetchOptions?),
  );
  final result = libEtebase.etebase_collection_manager_fetch(
    this_,
    colUid,
    fetchOptions,
  );
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<int>(
    invocation.id,
    pool
        .attachGlobal(
          result,
          libEtebase.etebase_collection_destroy,
        )
        .address,
  );
}

_i2.MethodResult _etebase_collection_manager_create(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 4,
      'Invocation must have exactly 4 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is String,
      'Parameter collectionType must be of type String');
  assert(invocation.arguments[2] is _i8.EtebaseItemMetadata,
      'Parameter meta must be of type EtebaseItemMetadata');
  assert(invocation.arguments[3] is _i11.TransferableTypedData,
      'Parameter content must be of type TransferableTypedData');
  final this_ = _i7.Pointer<_i3.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  final collectionType = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: pool)
      .cast<_i7.Char>();
  final meta = _etebaseItemMetadataToNative(
    libEtebase,
    pool,
    (invocation.arguments[2] as _i8.EtebaseItemMetadata),
  );
  final content_buffer = (invocation.arguments[3] as _i11.TransferableTypedData)
      .materialize()
      .asUint8List();
  final contentSize = content_buffer.length;
  final content = pool<_i7.Uint8>(contentSize);
  content.asTypedList(contentSize).setAll(
        0,
        content_buffer,
      );
  final result = libEtebase.etebase_collection_manager_create(
    this_,
    collectionType,
    meta,
    content.cast(),
    contentSize,
  );
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<int>(
    invocation.id,
    pool
        .attachGlobal(
          result,
          libEtebase.etebase_collection_destroy,
        )
        .address,
  );
}

_i2.MethodResult _etebase_collection_manager_create_raw(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 4,
      'Invocation must have exactly 4 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is String,
      'Parameter collectionType must be of type String');
  assert(invocation.arguments[2] is _i11.TransferableTypedData,
      'Parameter meta must be of type TransferableTypedData');
  assert(invocation.arguments[3] is _i11.TransferableTypedData,
      'Parameter content must be of type TransferableTypedData');
  final this_ = _i7.Pointer<_i3.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  final collectionType = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: pool)
      .cast<_i7.Char>();
  final meta_buffer = (invocation.arguments[2] as _i11.TransferableTypedData)
      .materialize()
      .asUint8List();
  final metaSize = meta_buffer.length;
  final meta = pool<_i7.Uint8>(metaSize);
  meta.asTypedList(metaSize).setAll(
        0,
        meta_buffer,
      );
  final content_buffer = (invocation.arguments[3] as _i11.TransferableTypedData)
      .materialize()
      .asUint8List();
  final contentSize = content_buffer.length;
  final content = pool<_i7.Uint8>(contentSize);
  content.asTypedList(contentSize).setAll(
        0,
        content_buffer,
      );
  final result = libEtebase.etebase_collection_manager_create_raw(
    this_,
    collectionType,
    meta.cast(),
    metaSize,
    content.cast(),
    contentSize,
  );
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<int>(
    invocation.id,
    pool
        .attachGlobal(
          result,
          libEtebase.etebase_collection_destroy,
        )
        .address,
  );
}

_i2.MethodResult _etebase_collection_manager_get_item_manager(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is int, 'Parameter col must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  final col = _i7.Pointer<_i3.EtebaseCollection>.fromAddress(
      (invocation.arguments[1] as int));
  final result = libEtebase.etebase_collection_manager_get_item_manager(
    this_,
    col,
  );
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<int>(
    invocation.id,
    pool
        .attachGlobal(
          result,
          libEtebase.etebase_item_manager_destroy,
        )
        .address,
  );
}

_i2.MethodResult _etebase_collection_manager_list(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is String,
      'Parameter collectionType must be of type String');
  assert(invocation.arguments[2] is _i8.EtebaseFetchOptions?,
      'Parameter fetchOptions must be of type EtebaseFetchOptions?');
  final this_ = _i7.Pointer<_i3.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  final collectionType = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: pool)
      .cast<_i7.Char>();
  final fetchOptions = _etebaseFetchOptionsToNative(
    libEtebase,
    pool,
    (invocation.arguments[2] as _i8.EtebaseFetchOptions?),
  );
  final result = libEtebase.etebase_collection_manager_list(
    this_,
    collectionType,
    fetchOptions,
  );
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<int>(
    invocation.id,
    pool
        .attachGlobal(
          result,
          libEtebase.etebase_collection_list_response_destroy,
        )
        .address,
  );
}

_i2.MethodResult _etebase_collection_manager_list_multi(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is List<String>,
      'Parameter collectionTypes must be of type List<String>');
  assert(invocation.arguments[2] is _i8.EtebaseFetchOptions?,
      'Parameter fetchOptions must be of type EtebaseFetchOptions?');
  final this_ = _i7.Pointer<_i3.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  final collectionTypesSize = (invocation.arguments[1] as List<String>).length;
  final collectionTypes = pool<_i7.Pointer<_i7.Char>>(collectionTypesSize);
  _i9.FfiHelpers.assignPointerList(
    collectionTypes,
    (invocation.arguments[1] as List<String>),
    (s) => s.toNativeUtf8(allocator: pool).cast<_i7.Char>(),
  );
  final fetchOptions = _etebaseFetchOptionsToNative(
    libEtebase,
    pool,
    (invocation.arguments[2] as _i8.EtebaseFetchOptions?),
  );
  final result = libEtebase.etebase_collection_manager_list_multi(
    this_,
    collectionTypes,
    collectionTypesSize,
    fetchOptions,
  );
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<int>(
    invocation.id,
    pool
        .attachGlobal(
          result,
          libEtebase.etebase_collection_list_response_destroy,
        )
        .address,
  );
}

_i2.MethodResult _etebase_collection_manager_upload(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is int,
      'Parameter collection must be of type int');
  assert(invocation.arguments[2] is _i8.EtebaseFetchOptions?,
      'Parameter fetchOptions must be of type EtebaseFetchOptions?');
  final this_ = _i7.Pointer<_i3.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  final collection = _i7.Pointer<_i3.EtebaseCollection>.fromAddress(
      (invocation.arguments[1] as int));
  final fetchOptions = _etebaseFetchOptionsToNative(
    libEtebase,
    pool,
    (invocation.arguments[2] as _i8.EtebaseFetchOptions?),
  );
  final result = libEtebase.etebase_collection_manager_upload(
    this_,
    collection,
    fetchOptions,
  );
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_collection_manager_transaction(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is int,
      'Parameter collection must be of type int');
  assert(invocation.arguments[2] is _i8.EtebaseFetchOptions?,
      'Parameter fetchOptions must be of type EtebaseFetchOptions?');
  final this_ = _i7.Pointer<_i3.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  final collection = _i7.Pointer<_i3.EtebaseCollection>.fromAddress(
      (invocation.arguments[1] as int));
  final fetchOptions = _etebaseFetchOptionsToNative(
    libEtebase,
    pool,
    (invocation.arguments[2] as _i8.EtebaseFetchOptions?),
  );
  final result = libEtebase.etebase_collection_manager_transaction(
    this_,
    collection,
    fetchOptions,
  );
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_collection_manager_cache_load(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is _i11.TransferableTypedData,
      'Parameter cached must be of type TransferableTypedData');
  final this_ = _i7.Pointer<_i3.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  final cached_buffer = (invocation.arguments[1] as _i11.TransferableTypedData)
      .materialize()
      .asUint8List();
  final cachedSize = cached_buffer.length;
  final cached = pool<_i7.Uint8>(cachedSize);
  cached.asTypedList(cachedSize).setAll(
        0,
        cached_buffer,
      );
  final result = libEtebase.etebase_collection_manager_cache_load(
    this_,
    cached.cast(),
    cachedSize,
  );
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<int>(
    invocation.id,
    pool
        .attachGlobal(
          result,
          libEtebase.etebase_collection_destroy,
        )
        .address,
  );
}

_i2.MethodResult _etebase_collection_manager_cache_save(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is int,
      'Parameter collection must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  final collection = _i7.Pointer<_i3.EtebaseCollection>.fromAddress(
      (invocation.arguments[1] as int));
  final retSize = pool<_i7.UintPtr>()..value = 0;
  final result = libEtebase.etebase_collection_manager_cache_save(
    this_,
    collection,
    retSize,
  );
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<_i11.TransferableTypedData>(
    invocation.id,
    _i11.TransferableTypedData.fromList([
      pool.attachScoped(result).cast<_i7.Uint8>().asTypedList(retSize.value)
    ]),
  );
}

_i2.MethodResult _etebase_collection_manager_cache_save_with_content(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is int,
      'Parameter collection must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  final collection = _i7.Pointer<_i3.EtebaseCollection>.fromAddress(
      (invocation.arguments[1] as int));
  final retSize = pool<_i7.UintPtr>()..value = 0;
  final result = libEtebase.etebase_collection_manager_cache_save_with_content(
    this_,
    collection,
    retSize,
  );
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<_i11.TransferableTypedData>(
    invocation.id,
    _i11.TransferableTypedData.fromList([
      pool.attachScoped(result).cast<_i7.Uint8>().asTypedList(retSize.value)
    ]),
  );
}

_i2.MethodResult _etebase_collection_manager_get_member_manager(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is int, 'Parameter col must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  final col = _i7.Pointer<_i3.EtebaseCollection>.fromAddress(
      (invocation.arguments[1] as int));
  final result = libEtebase.etebase_collection_manager_get_member_manager(
    this_,
    col,
  );
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<int>(
    invocation.id,
    pool
        .attachGlobal(
          result,
          libEtebase.etebase_collection_member_manager_destroy,
        )
        .address,
  );
}

_i2.MethodResult _etebase_collection_manager_destroy(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  pool.freeGlobal(this_);
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_collection_list_response_get_stoken(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseCollectionListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_list_response_get_stoken(this_);
  return _i2.MethodResult.successTyped<String?>(
    invocation.id,
    result == _i7.nullptr ? null : result.cast<_i10.Utf8>().toDartString(),
  );
}

_i2.MethodResult _etebase_collection_list_response_get_data(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseCollectionListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  final dataSize =
      libEtebase.etebase_collection_list_response_get_data_length(this_);
  final data = pool<_i7.Pointer<_i3.EtebaseCollection>>(dataSize);
  final result = libEtebase.etebase_collection_list_response_get_data(
    this_,
    data,
  );
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<List<int>>(
    invocation.id,
    _i9.FfiHelpers.extractPointerList(
      data,
      dataSize,
      (p) => p.address,
    ),
  );
}

_i2.MethodResult _etebase_collection_list_response_is_done(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseCollectionListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_list_response_is_done(this_);
  return _i2.MethodResult.successTyped<bool>(
    invocation.id,
    result,
  );
}

_i2.MethodResult _etebase_collection_list_response_get_removed_memberships(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseCollectionListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  final dataSize = libEtebase
      .etebase_collection_list_response_get_removed_memberships_length(this_);
  final data = pool<_i7.Pointer<_i3.EtebaseRemovedCollection>>(dataSize);
  final result =
      libEtebase.etebase_collection_list_response_get_removed_memberships(
    this_,
    data,
  );
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<List<int>>(
    invocation.id,
    _i9.FfiHelpers.extractPointerList(
      data,
      dataSize,
      (p) => p.address,
    ),
  );
}

_i2.MethodResult _etebase_collection_list_response_destroy(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseCollectionListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  pool.freeGlobal(this_);
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_invitation_manager_list_incoming(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is _i8.EtebaseFetchOptions?,
      'Parameter fetchOptions must be of type EtebaseFetchOptions?');
  final this_ = _i7.Pointer<_i3.EtebaseCollectionInvitationManager>.fromAddress(
      (invocation.arguments[0] as int));
  final fetchOptions = _etebaseFetchOptionsToNative(
    libEtebase,
    pool,
    (invocation.arguments[1] as _i8.EtebaseFetchOptions?),
  );
  final result = libEtebase.etebase_invitation_manager_list_incoming(
    this_,
    fetchOptions,
  );
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<int>(
    invocation.id,
    pool
        .attachGlobal(
          result,
          libEtebase.etebase_invitation_list_response_destroy,
        )
        .address,
  );
}

_i2.MethodResult _etebase_invitation_manager_list_outgoing(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is _i8.EtebaseFetchOptions?,
      'Parameter fetchOptions must be of type EtebaseFetchOptions?');
  final this_ = _i7.Pointer<_i3.EtebaseCollectionInvitationManager>.fromAddress(
      (invocation.arguments[0] as int));
  final fetchOptions = _etebaseFetchOptionsToNative(
    libEtebase,
    pool,
    (invocation.arguments[1] as _i8.EtebaseFetchOptions?),
  );
  final result = libEtebase.etebase_invitation_manager_list_outgoing(
    this_,
    fetchOptions,
  );
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<int>(
    invocation.id,
    pool
        .attachGlobal(
          result,
          libEtebase.etebase_invitation_list_response_destroy,
        )
        .address,
  );
}

_i2.MethodResult _etebase_invitation_manager_accept(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is int,
      'Parameter invitation must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseCollectionInvitationManager>.fromAddress(
      (invocation.arguments[0] as int));
  final invitation = _i7.Pointer<_i3.EtebaseSignedInvitation>.fromAddress(
      (invocation.arguments[1] as int));
  final result = libEtebase.etebase_invitation_manager_accept(
    this_,
    invitation,
  );
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_invitation_manager_reject(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is int,
      'Parameter invitation must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseCollectionInvitationManager>.fromAddress(
      (invocation.arguments[0] as int));
  final invitation = _i7.Pointer<_i3.EtebaseSignedInvitation>.fromAddress(
      (invocation.arguments[1] as int));
  final result = libEtebase.etebase_invitation_manager_reject(
    this_,
    invitation,
  );
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_invitation_manager_fetch_user_profile(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is String,
      'Parameter username must be of type String');
  final this_ = _i7.Pointer<_i3.EtebaseCollectionInvitationManager>.fromAddress(
      (invocation.arguments[0] as int));
  final username = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: pool)
      .cast<_i7.Char>();
  final result = libEtebase.etebase_invitation_manager_fetch_user_profile(
    this_,
    username,
  );
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<int>(
    invocation.id,
    pool
        .attachGlobal(
          result,
          libEtebase.etebase_user_profile_destroy,
        )
        .address,
  );
}

_i2.MethodResult _etebase_invitation_manager_invite(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 5,
      'Invocation must have exactly 5 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is int,
      'Parameter collection must be of type int');
  assert(invocation.arguments[2] is String,
      'Parameter username must be of type String');
  assert(invocation.arguments[3] is _i11.TransferableTypedData,
      'Parameter pubkey must be of type TransferableTypedData');
  assert(invocation.arguments[4] is _i12.EtebaseCollectionAccessLevel,
      'Parameter accessLevel must be of type EtebaseCollectionAccessLevel');
  final this_ = _i7.Pointer<_i3.EtebaseCollectionInvitationManager>.fromAddress(
      (invocation.arguments[0] as int));
  final collection = _i7.Pointer<_i3.EtebaseCollection>.fromAddress(
      (invocation.arguments[1] as int));
  final username = (invocation.arguments[2] as String)
      .toNativeUtf8(allocator: pool)
      .cast<_i7.Char>();
  final pubkey_buffer = (invocation.arguments[3] as _i11.TransferableTypedData)
      .materialize()
      .asUint8List();
  final pubkeySize = pubkey_buffer.length;
  final pubkey = pool<_i7.Uint8>(pubkeySize);
  pubkey.asTypedList(pubkeySize).setAll(
        0,
        pubkey_buffer,
      );
  final accessLevel =
      (invocation.arguments[4] as _i12.EtebaseCollectionAccessLevel).index;
  final result = libEtebase.etebase_invitation_manager_invite(
    this_,
    collection,
    username,
    pubkey.cast(),
    pubkeySize,
    accessLevel,
  );
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_invitation_manager_disinvite(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is int,
      'Parameter invitation must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseCollectionInvitationManager>.fromAddress(
      (invocation.arguments[0] as int));
  final invitation = _i7.Pointer<_i3.EtebaseSignedInvitation>.fromAddress(
      (invocation.arguments[1] as int));
  final result = libEtebase.etebase_invitation_manager_disinvite(
    this_,
    invitation,
  );
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_invitation_manager_get_pubkey(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseCollectionInvitationManager>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_invitation_manager_get_pubkey(this_);
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<_i11.TransferableTypedData>(
    invocation.id,
    _i11.TransferableTypedData.fromList([
      result.cast<_i7.Uint8>().asTypedList(
          libEtebase.etebase_invitation_manager_get_pubkey_size(this_))
    ]),
  );
}

_i2.MethodResult _etebase_invitation_manager_destroy(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseCollectionInvitationManager>.fromAddress(
      (invocation.arguments[0] as int));
  pool.freeGlobal(this_);
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_collection_clone(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_clone(this_);
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<int>(
    invocation.id,
    pool
        .attachGlobal(
          result,
          libEtebase.etebase_collection_destroy,
        )
        .address,
  );
}

_i2.MethodResult _etebase_collection_verify(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_verify(this_);
  return _i2.MethodResult.successTyped<bool>(
    invocation.id,
    result,
  );
}

_i2.MethodResult _etebase_collection_set_meta(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is _i8.EtebaseItemMetadata,
      'Parameter meta must be of type EtebaseItemMetadata');
  final this_ = _i7.Pointer<_i3.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final meta = _etebaseItemMetadataToNative(
    libEtebase,
    pool,
    (invocation.arguments[1] as _i8.EtebaseItemMetadata),
  );
  final result = libEtebase.etebase_collection_set_meta(
    this_,
    meta,
  );
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_collection_get_meta(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_get_meta(this_);
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<_i8.EtebaseItemMetadata>(
    invocation.id,
    _etebaseItemMetadataFromNative(
      libEtebase,
      pool,
      result,
    ),
  );
}

_i2.MethodResult _etebase_collection_set_meta_raw(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is _i11.TransferableTypedData,
      'Parameter meta must be of type TransferableTypedData');
  final this_ = _i7.Pointer<_i3.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final meta_buffer = (invocation.arguments[1] as _i11.TransferableTypedData)
      .materialize()
      .asUint8List();
  final metaSize = meta_buffer.length;
  final meta = pool<_i7.Uint8>(metaSize);
  meta.asTypedList(metaSize).setAll(
        0,
        meta_buffer,
      );
  final result = libEtebase.etebase_collection_set_meta_raw(
    this_,
    meta.cast(),
    metaSize,
  );
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_collection_get_meta_raw(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation, {
  int? reinvokedWithSize,
}) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is int?,
      'Parameter sizeHint must be of type int?');
  final this_ = _i7.Pointer<_i3.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final bufSize = reinvokedWithSize ??
      (invocation.arguments[1] as int?) ??
      config.defaultContentBufferSize;
  final buf = pool<_i7.Uint8>(bufSize);
  final result = libEtebase.etebase_collection_get_meta_raw(
    this_,
    buf.cast(),
    bufSize,
  );
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  } else if (result <= bufSize) {
    return _i2.MethodResult.successTyped<_i11.TransferableTypedData>(
      invocation.id,
      _i11.TransferableTypedData.fromList(
          [buf.cast<_i7.Uint8>().asTypedList(result)]),
    );
  } else if (reinvokedWithSize != null) {
    return _i2.MethodResult.failure(
      invocation.id,
      _i13.EtebaseErrorCode.generic,
      'output size of etebase_collection_get_meta_raw changed during invocation',
    );
  } else {
    return _etebase_collection_get_meta_raw(
      libEtebase,
      pool,
      config,
      invocation,
      reinvokedWithSize: result,
    );
  }
}

_i2.MethodResult _etebase_collection_set_content(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is _i11.TransferableTypedData,
      'Parameter content must be of type TransferableTypedData');
  final this_ = _i7.Pointer<_i3.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final content_buffer = (invocation.arguments[1] as _i11.TransferableTypedData)
      .materialize()
      .asUint8List();
  final contentSize = content_buffer.length;
  final content = pool<_i7.Uint8>(contentSize);
  content.asTypedList(contentSize).setAll(
        0,
        content_buffer,
      );
  final result = libEtebase.etebase_collection_set_content(
    this_,
    content.cast(),
    contentSize,
  );
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_collection_get_content(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation, {
  int? reinvokedWithSize,
}) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is int?,
      'Parameter sizeHint must be of type int?');
  final this_ = _i7.Pointer<_i3.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final bufSize = reinvokedWithSize ??
      (invocation.arguments[1] as int?) ??
      config.defaultContentBufferSize;
  final buf = pool<_i7.Uint8>(bufSize);
  final result = libEtebase.etebase_collection_get_content(
    this_,
    buf.cast(),
    bufSize,
  );
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  } else if (result <= bufSize) {
    return _i2.MethodResult.successTyped<_i11.TransferableTypedData>(
      invocation.id,
      _i11.TransferableTypedData.fromList(
          [buf.cast<_i7.Uint8>().asTypedList(result)]),
    );
  } else if (reinvokedWithSize != null) {
    return _i2.MethodResult.failure(
      invocation.id,
      _i13.EtebaseErrorCode.generic,
      'output size of etebase_collection_get_content changed during invocation',
    );
  } else {
    return _etebase_collection_get_content(
      libEtebase,
      pool,
      config,
      invocation,
      reinvokedWithSize: result,
    );
  }
}

_i2.MethodResult _etebase_collection_delete(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_delete(this_);
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_collection_is_deleted(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_is_deleted(this_);
  return _i2.MethodResult.successTyped<bool>(
    invocation.id,
    result,
  );
}

_i2.MethodResult _etebase_collection_get_uid(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_get_uid(this_);
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<String>(
    invocation.id,
    result.cast<_i10.Utf8>().toDartString(),
  );
}

_i2.MethodResult _etebase_collection_get_etag(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_get_etag(this_);
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<String>(
    invocation.id,
    result.cast<_i10.Utf8>().toDartString(),
  );
}

_i2.MethodResult _etebase_collection_get_stoken(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_get_stoken(this_);
  return _i2.MethodResult.successTyped<String?>(
    invocation.id,
    result == _i7.nullptr ? null : result.cast<_i10.Utf8>().toDartString(),
  );
}

_i2.MethodResult _etebase_collection_as_item(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_as_item(this_);
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<int>(
    invocation.id,
    pool
        .attachGlobal(
          result,
          libEtebase.etebase_item_destroy,
        )
        .address,
  );
}

_i2.MethodResult _etebase_collection_get_collection_type(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_get_collection_type(this_);
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<String>(
    invocation.id,
    pool.attachScoped(result).cast<_i10.Utf8>().toDartString(),
  );
}

_i2.MethodResult _etebase_collection_get_access_level(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_get_access_level(this_);
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<_i12.EtebaseCollectionAccessLevel>(
    invocation.id,
    _i12.EtebaseCollectionAccessLevel.values[result],
  );
}

_i2.MethodResult _etebase_collection_destroy(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  pool.freeGlobal(this_);
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_client_new(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is String,
      'Parameter clientName must be of type String');
  assert(invocation.arguments[1] is Uri,
      'Parameter serverUrl must be of type Uri');
  final clientName = (invocation.arguments[0] as String)
      .toNativeUtf8(allocator: pool)
      .cast<_i7.Char>();
  final serverUrl = (invocation.arguments[1] as Uri)
      .toString()
      .toNativeUtf8(allocator: pool)
      .cast<_i7.Char>();
  final result = libEtebase.etebase_client_new(
    clientName,
    serverUrl,
  );
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<int>(
    invocation.id,
    pool
        .attachGlobal(
          result,
          libEtebase.etebase_client_destroy,
        )
        .address,
  );
}

_i2.MethodResult _etebase_client_set_server_url(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is Uri,
      'Parameter serverUrl must be of type Uri');
  final this_ = _i7.Pointer<_i3.EtebaseClient>.fromAddress(
      (invocation.arguments[0] as int));
  final serverUrl = (invocation.arguments[1] as Uri)
      .toString()
      .toNativeUtf8(allocator: pool)
      .cast<_i7.Char>();
  final result = libEtebase.etebase_client_set_server_url(
    this_,
    serverUrl,
  );
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_client_check_etebase_server(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(
      invocation.arguments[0] is int, 'Parameter client must be of type int');
  final client = _i7.Pointer<_i3.EtebaseClient>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_client_check_etebase_server(client);
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<bool>(
    invocation.id,
    result == 0,
  );
}

_i2.MethodResult _etebase_client_destroy(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseClient>.fromAddress(
      (invocation.arguments[0] as int));
  pool.freeGlobal(this_);
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_account_login(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  assert(
      invocation.arguments[0] is int, 'Parameter client must be of type int');
  assert(invocation.arguments[1] is String,
      'Parameter username must be of type String');
  assert(invocation.arguments[2] is String,
      'Parameter password must be of type String');
  final client = _i7.Pointer<_i3.EtebaseClient>.fromAddress(
      (invocation.arguments[0] as int));
  final username = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: pool)
      .cast<_i7.Char>();
  final password = (invocation.arguments[2] as String)
      .toNativeUtf8(allocator: pool)
      .cast<_i7.Char>();
  final result = libEtebase.etebase_account_login(
    client,
    username,
    password,
  );
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<int>(
    invocation.id,
    pool
        .attachGlobal(
          result,
          libEtebase.etebase_account_destroy,
        )
        .address,
  );
}

_i2.MethodResult _etebase_account_signup(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  assert(
      invocation.arguments[0] is int, 'Parameter client must be of type int');
  assert(invocation.arguments[1] is _i8.EtebaseUser,
      'Parameter user must be of type EtebaseUser');
  assert(invocation.arguments[2] is String,
      'Parameter password must be of type String');
  final client = _i7.Pointer<_i3.EtebaseClient>.fromAddress(
      (invocation.arguments[0] as int));
  final user = _etebaseUserToNative(
    libEtebase,
    pool,
    (invocation.arguments[1] as _i8.EtebaseUser),
  );
  final password = (invocation.arguments[2] as String)
      .toNativeUtf8(allocator: pool)
      .cast<_i7.Char>();
  final result = libEtebase.etebase_account_signup(
    client,
    user,
    password,
  );
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<int>(
    invocation.id,
    pool
        .attachGlobal(
          result,
          libEtebase.etebase_account_destroy,
        )
        .address,
  );
}

_i2.MethodResult _etebase_account_fetch_token(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseAccount>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_account_fetch_token(this_);
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_account_fetch_dashboard_url(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseAccount>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_account_fetch_dashboard_url(this_);
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<Uri>(
    invocation.id,
    Uri.parse(pool.attachScoped(result).cast<_i10.Utf8>().toDartString()),
  );
}

_i2.MethodResult _etebase_account_force_server_url(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is Uri,
      'Parameter serverUrl must be of type Uri');
  final this_ = _i7.Pointer<_i3.EtebaseAccount>.fromAddress(
      (invocation.arguments[0] as int));
  final serverUrl = (invocation.arguments[1] as Uri)
      .toString()
      .toNativeUtf8(allocator: pool)
      .cast<_i7.Char>();
  final result = libEtebase.etebase_account_force_server_url(
    this_,
    serverUrl,
  );
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_account_change_password(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is String,
      'Parameter password must be of type String');
  final this_ = _i7.Pointer<_i3.EtebaseAccount>.fromAddress(
      (invocation.arguments[0] as int));
  final password = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: pool)
      .cast<_i7.Char>();
  final result = libEtebase.etebase_account_change_password(
    this_,
    password,
  );
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_account_logout(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseAccount>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_account_logout(this_);
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_account_get_collection_manager(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseAccount>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_account_get_collection_manager(this_);
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<int>(
    invocation.id,
    pool
        .attachGlobal(
          result,
          libEtebase.etebase_collection_manager_destroy,
        )
        .address,
  );
}

_i2.MethodResult _etebase_account_get_invitation_manager(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseAccount>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_account_get_invitation_manager(this_);
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<int>(
    invocation.id,
    pool
        .attachGlobal(
          result,
          libEtebase.etebase_invitation_manager_destroy,
        )
        .address,
  );
}

_i2.MethodResult _etebase_account_save(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is _i11.TransferableTypedData?,
      'Parameter encryptionKey must be of type TransferableTypedData?');
  final this_ = _i7.Pointer<_i3.EtebaseAccount>.fromAddress(
      (invocation.arguments[0] as int));
  final encryptionKey_buffer =
      (invocation.arguments[1] as _i11.TransferableTypedData?)
          ?.materialize()
          .asUint8List();
  final encryptionKeySize = encryptionKey_buffer?.length ?? 0;
  if (encryptionKey_buffer != null && encryptionKeySize != 32) {
    throw ArgumentError(
      'should be 32 bytes long, but has $encryptionKeySize bytes',
      'encryptionKey',
    );
  }
  final encryptionKey = encryptionKey_buffer == null
      ? _i7.nullptr
      : pool<_i7.Uint8>(encryptionKeySize);
  if (encryptionKey_buffer != null) {
    encryptionKey.asTypedList(encryptionKeySize).setAll(
          0,
          encryptionKey_buffer,
        );
  }
  final result = libEtebase.etebase_account_save(
    this_,
    encryptionKey.cast(),
    encryptionKeySize,
  );
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<String>(
    invocation.id,
    pool.attachScoped(result).cast<_i10.Utf8>().toDartString(),
  );
}

_i2.MethodResult _etebase_account_restore(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  assert(
      invocation.arguments[0] is int, 'Parameter client must be of type int');
  assert(invocation.arguments[1] is String,
      'Parameter accountDataStored must be of type String');
  assert(invocation.arguments[2] is _i11.TransferableTypedData?,
      'Parameter encryptionKey must be of type TransferableTypedData?');
  final client = _i7.Pointer<_i3.EtebaseClient>.fromAddress(
      (invocation.arguments[0] as int));
  final accountDataStored = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: pool)
      .cast<_i7.Char>();
  final encryptionKey_buffer =
      (invocation.arguments[2] as _i11.TransferableTypedData?)
          ?.materialize()
          .asUint8List();
  final encryptionKeySize = encryptionKey_buffer?.length ?? 0;
  if (encryptionKey_buffer != null && encryptionKeySize != 32) {
    throw ArgumentError(
      'should be 32 bytes long, but has $encryptionKeySize bytes',
      'encryptionKey',
    );
  }
  final encryptionKey = encryptionKey_buffer == null
      ? _i7.nullptr
      : pool<_i7.Uint8>(encryptionKeySize);
  if (encryptionKey_buffer != null) {
    encryptionKey.asTypedList(encryptionKeySize).setAll(
          0,
          encryptionKey_buffer,
        );
  }
  final result = libEtebase.etebase_account_restore(
    client,
    accountDataStored,
    encryptionKey.cast(),
    encryptionKeySize,
  );
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<int>(
    invocation.id,
    pool
        .attachGlobal(
          result,
          libEtebase.etebase_account_destroy,
        )
        .address,
  );
}

_i2.MethodResult _etebase_account_destroy(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i7.Pointer<_i3.EtebaseAccount>.fromAddress(
      (invocation.arguments[0] as int));
  pool.freeGlobal(this_);
  return _i2.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i2.MethodResult _etebase_utils_randombytes(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter size must be of type int');
  final size = (invocation.arguments[0] as int);
  final buf = pool<_i7.Uint8>(size);
  final result = libEtebase.etebase_utils_randombytes(
    buf.cast(),
    size,
  );
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<_i11.TransferableTypedData>(
    invocation.id,
    _i11.TransferableTypedData.fromList(
        [buf.cast<_i7.Uint8>().asTypedList(size)]),
  );
}

_i2.MethodResult _etebase_utils_pretty_fingerprint(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is _i11.TransferableTypedData,
      'Parameter content must be of type TransferableTypedData');
  final content_buffer = (invocation.arguments[0] as _i11.TransferableTypedData)
      .materialize()
      .asUint8List();
  final contentSize = content_buffer.length;
  final content = pool<_i7.Uint8>(contentSize);
  content.asTypedList(contentSize).setAll(
        0,
        content_buffer,
      );
  final buf = pool<_i7.Char>(libEtebase.ETEBASE_UTILS_PRETTY_FINGERPRINT_SIZE);
  final result = libEtebase.etebase_utils_pretty_fingerprint(
    content.cast(),
    contentSize,
    buf,
  );
  if (result < 0) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<String>(
    invocation.id,
    buf.cast<_i10.Utf8>().toDartString(length: 89),
  );
}

_i2.MethodResult _etebase_get_default_server_url(
  _i3.LibEtebaseFFI libEtebase,
  _i4.EtebasePool pool,
  _i5.EtebaseConfig config,
  _i6.MethodInvocation invocation,
) {
  assert(invocation.arguments.length == 0,
      'Invocation must have exactly 0 arguments');
  final result = libEtebase.etebase_get_default_server_url();
  if (result == _i7.nullptr) {
    return _i9.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i2.MethodResult.successTyped<Uri>(
    invocation.id,
    Uri.parse(result.cast<_i10.Utf8>().toDartString()),
  );
}
