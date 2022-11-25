// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// EtebaseIsolateGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, require_trailing_commas, unnecessary_parenthesis, prefer_relative_imports, lines_longer_than_80_chars, prefer_is_empty, constant_identifier_names, avoid_bool_literals_in_conditional_expressions
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:ffi' as _i5;
import 'dart:isolate' as _i7;

import 'package:etebase/gen/ffi/libetebase.ffi.dart' as _i2;
import 'package:etebase/src/isolate/etebase_arena.dart' as _i4;
import 'package:etebase/src/isolate/ffi_helpers.dart' as _i6;
import 'package:etebase/src/isolate/method_invocation.dart' as _i3;
import 'package:etebase/src/isolate/method_result.dart' as _i1;
import 'package:etebase/src/model/etebase_collection_access_level.dart' as _i9;
import 'package:etebase/src/model/etebase_prefetch_option.dart' as _i10;
import 'package:ffi/ffi.dart' as _i8;
import 'package:ffi/ffi.dart';

_i1.MethodResult etebaseIsolateMessageHandler(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  final arena = _i4.EtebaseArena();
  try {
    switch (invocation.method) {
      case #etebase_user_profile_get_pubkey:
        return _etebase_user_profile_get_pubkey(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_user_profile_destroy:
        return _etebase_user_profile_destroy(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_user_new:
        return _etebase_user_new(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_user_set_username:
        return _etebase_user_set_username(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_user_get_username:
        return _etebase_user_get_username(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_user_set_email:
        return _etebase_user_set_email(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_user_get_email:
        return _etebase_user_get_email(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_user_destroy:
        return _etebase_user_destroy(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_signed_invitation_clone:
        return _etebase_signed_invitation_clone(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_signed_invitation_get_uid:
        return _etebase_signed_invitation_get_uid(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_signed_invitation_get_username:
        return _etebase_signed_invitation_get_username(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_signed_invitation_get_collection:
        return _etebase_signed_invitation_get_collection(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_signed_invitation_get_access_level:
        return _etebase_signed_invitation_get_access_level(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_signed_invitation_get_from_username:
        return _etebase_signed_invitation_get_from_username(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_signed_invitation_get_from_pubkey:
        return _etebase_signed_invitation_get_from_pubkey(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_signed_invitation_destroy:
        return _etebase_signed_invitation_destroy(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_removed_collection_get_uid:
        return _etebase_removed_collection_get_uid(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_removed_collection_destroy:
        return _etebase_removed_collection_destroy(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_invitation_list_response_get_iterator:
        return _etebase_invitation_list_response_get_iterator(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_invitation_list_response_get_data:
        return _etebase_invitation_list_response_get_data(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_invitation_list_response_is_done:
        return _etebase_invitation_list_response_is_done(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_invitation_list_response_destroy:
        return _etebase_invitation_list_response_destroy(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_item_revisions_list_response_get_iterator:
        return _etebase_item_revisions_list_response_get_iterator(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_item_revisions_list_response_get_data:
        return _etebase_item_revisions_list_response_get_data(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_item_revisions_list_response_is_done:
        return _etebase_item_revisions_list_response_is_done(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_item_revisions_list_response_destroy:
        return _etebase_item_revisions_list_response_destroy(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_member_list_response_get_iterator:
        return _etebase_member_list_response_get_iterator(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_member_list_response_get_data:
        return _etebase_member_list_response_get_data(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_member_list_response_is_done:
        return _etebase_member_list_response_is_done(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_member_list_response_destroy:
        return _etebase_member_list_response_destroy(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_item_metadata_new:
        return _etebase_item_metadata_new(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_item_metadata_set_item_type:
        return _etebase_item_metadata_set_item_type(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_item_metadata_get_item_type:
        return _etebase_item_metadata_get_item_type(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_item_metadata_set_name:
        return _etebase_item_metadata_set_name(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_item_metadata_get_name:
        return _etebase_item_metadata_get_name(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_item_metadata_set_mtime:
        return _etebase_item_metadata_set_mtime(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_item_metadata_get_mtime:
        return _etebase_item_metadata_get_mtime(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_item_metadata_set_description:
        return _etebase_item_metadata_set_description(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_item_metadata_get_description:
        return _etebase_item_metadata_get_description(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_item_metadata_set_color:
        return _etebase_item_metadata_set_color(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_item_metadata_get_color:
        return _etebase_item_metadata_get_color(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_item_metadata_destroy:
        return _etebase_item_metadata_destroy(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_item_manager_fetch:
        return _etebase_item_manager_fetch(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_item_manager_create:
        return _etebase_item_manager_create(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_item_manager_create_raw:
        return _etebase_item_manager_create_raw(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_item_manager_list:
        return _etebase_item_manager_list(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_item_manager_item_revisions:
        return _etebase_item_manager_item_revisions(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_item_manager_fetch_updates:
        return _etebase_item_manager_fetch_updates(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_item_manager_fetch_multi:
        return _etebase_item_manager_fetch_multi(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_item_manager_batch:
        return _etebase_item_manager_batch(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_item_manager_batch_deps:
        return _etebase_item_manager_batch_deps(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_item_manager_transaction:
        return _etebase_item_manager_transaction(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_item_manager_transaction_deps:
        return _etebase_item_manager_transaction_deps(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_item_manager_cache_load:
        return _etebase_item_manager_cache_load(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_item_manager_cache_save:
        return _etebase_item_manager_cache_save(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_item_manager_cache_save_with_content:
        return _etebase_item_manager_cache_save_with_content(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_item_manager_destroy:
        return _etebase_item_manager_destroy(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_item_list_response_get_stoken:
        return _etebase_item_list_response_get_stoken(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_item_list_response_get_data:
        return _etebase_item_list_response_get_data(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_item_list_response_is_done:
        return _etebase_item_list_response_is_done(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_item_list_response_destroy:
        return _etebase_item_list_response_destroy(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_item_clone:
        return _etebase_item_clone(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_item_verify:
        return _etebase_item_verify(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_item_set_meta:
        return _etebase_item_set_meta(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_item_get_meta:
        return _etebase_item_get_meta(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_item_set_meta_raw:
        return _etebase_item_set_meta_raw(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_item_get_meta_raw:
        return _etebase_item_get_meta_raw(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_item_set_content:
        return _etebase_item_set_content(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_item_get_content:
        return _etebase_item_get_content(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_item_delete:
        return _etebase_item_delete(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_item_is_deleted:
        return _etebase_item_is_deleted(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_item_get_uid:
        return _etebase_item_get_uid(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_item_get_etag:
        return _etebase_item_get_etag(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_item_destroy:
        return _etebase_item_destroy(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_fs_cache_new:
        return _etebase_fs_cache_new(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_fs_cache_clear_user:
        return _etebase_fs_cache_clear_user(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_fs_cache_save_account:
        return _etebase_fs_cache_save_account(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_fs_cache_load_account:
        return _etebase_fs_cache_load_account(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_fs_cache_save_stoken:
        return _etebase_fs_cache_save_stoken(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_fs_cache_load_stoken:
        return _etebase_fs_cache_load_stoken(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_fs_cache_collection_save_stoken:
        return _etebase_fs_cache_collection_save_stoken(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_fs_cache_collection_load_stoken:
        return _etebase_fs_cache_collection_load_stoken(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_fs_cache_collection_set:
        return _etebase_fs_cache_collection_set(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_fs_cache_collection_unset:
        return _etebase_fs_cache_collection_unset(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_fs_cache_collection_get:
        return _etebase_fs_cache_collection_get(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_fs_cache_item_set:
        return _etebase_fs_cache_item_set(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_fs_cache_item_unset:
        return _etebase_fs_cache_item_unset(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_fs_cache_item_get:
        return _etebase_fs_cache_item_get(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_fs_cache_destroy:
        return _etebase_fs_cache_destroy(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_fetch_options_new:
        return _etebase_fetch_options_new(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_fetch_options_set_limit:
        return _etebase_fetch_options_set_limit(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_fetch_options_set_prefetch:
        return _etebase_fetch_options_set_prefetch(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_fetch_options_set_with_collection:
        return _etebase_fetch_options_set_with_collection(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_fetch_options_set_iterator:
        return _etebase_fetch_options_set_iterator(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_fetch_options_set_stoken:
        return _etebase_fetch_options_set_stoken(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_fetch_options_destroy:
        return _etebase_fetch_options_destroy(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_collection_member_manager_list:
        return _etebase_collection_member_manager_list(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_collection_member_manager_remove:
        return _etebase_collection_member_manager_remove(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_collection_member_manager_leave:
        return _etebase_collection_member_manager_leave(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_collection_member_manager_modify_access_level:
        return _etebase_collection_member_manager_modify_access_level(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_collection_member_manager_destroy:
        return _etebase_collection_member_manager_destroy(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_collection_member_clone:
        return _etebase_collection_member_clone(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_collection_member_get_username:
        return _etebase_collection_member_get_username(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_collection_member_get_access_level:
        return _etebase_collection_member_get_access_level(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_collection_member_destroy:
        return _etebase_collection_member_destroy(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_collection_manager_fetch:
        return _etebase_collection_manager_fetch(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_collection_manager_create:
        return _etebase_collection_manager_create(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_collection_manager_create_raw:
        return _etebase_collection_manager_create_raw(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_collection_manager_get_item_manager:
        return _etebase_collection_manager_get_item_manager(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_collection_manager_list:
        return _etebase_collection_manager_list(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_collection_manager_list_multi:
        return _etebase_collection_manager_list_multi(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_collection_manager_upload:
        return _etebase_collection_manager_upload(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_collection_manager_transaction:
        return _etebase_collection_manager_transaction(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_collection_manager_cache_load:
        return _etebase_collection_manager_cache_load(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_collection_manager_cache_save:
        return _etebase_collection_manager_cache_save(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_collection_manager_cache_save_with_content:
        return _etebase_collection_manager_cache_save_with_content(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_collection_manager_get_member_manager:
        return _etebase_collection_manager_get_member_manager(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_collection_manager_destroy:
        return _etebase_collection_manager_destroy(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_collection_list_response_get_stoken:
        return _etebase_collection_list_response_get_stoken(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_collection_list_response_get_data:
        return _etebase_collection_list_response_get_data(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_collection_list_response_is_done:
        return _etebase_collection_list_response_is_done(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_collection_list_response_get_removed_memberships:
        return _etebase_collection_list_response_get_removed_memberships(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_collection_list_response_destroy:
        return _etebase_collection_list_response_destroy(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_invitation_manager_list_incoming:
        return _etebase_invitation_manager_list_incoming(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_invitation_manager_list_outgoing:
        return _etebase_invitation_manager_list_outgoing(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_invitation_manager_accept:
        return _etebase_invitation_manager_accept(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_invitation_manager_reject:
        return _etebase_invitation_manager_reject(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_invitation_manager_fetch_user_profile:
        return _etebase_invitation_manager_fetch_user_profile(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_invitation_manager_invite:
        return _etebase_invitation_manager_invite(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_invitation_manager_disinvite:
        return _etebase_invitation_manager_disinvite(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_invitation_manager_get_pubkey:
        return _etebase_invitation_manager_get_pubkey(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_invitation_manager_destroy:
        return _etebase_invitation_manager_destroy(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_collection_clone:
        return _etebase_collection_clone(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_collection_verify:
        return _etebase_collection_verify(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_collection_set_meta:
        return _etebase_collection_set_meta(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_collection_get_meta:
        return _etebase_collection_get_meta(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_collection_set_meta_raw:
        return _etebase_collection_set_meta_raw(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_collection_get_meta_raw:
        return _etebase_collection_get_meta_raw(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_collection_set_content:
        return _etebase_collection_set_content(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_collection_get_content:
        return _etebase_collection_get_content(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_collection_delete:
        return _etebase_collection_delete(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_collection_is_deleted:
        return _etebase_collection_is_deleted(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_collection_get_uid:
        return _etebase_collection_get_uid(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_collection_get_etag:
        return _etebase_collection_get_etag(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_collection_get_stoken:
        return _etebase_collection_get_stoken(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_collection_as_item:
        return _etebase_collection_as_item(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_collection_get_collection_type:
        return _etebase_collection_get_collection_type(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_collection_get_access_level:
        return _etebase_collection_get_access_level(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_collection_destroy:
        return _etebase_collection_destroy(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_client_new:
        return _etebase_client_new(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_client_set_server_url:
        return _etebase_client_set_server_url(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_client_check_etebase_server:
        return _etebase_client_check_etebase_server(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_client_destroy:
        return _etebase_client_destroy(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_account_login:
        return _etebase_account_login(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_account_signup:
        return _etebase_account_signup(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_account_fetch_token:
        return _etebase_account_fetch_token(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_account_fetch_dashboard_url:
        return _etebase_account_fetch_dashboard_url(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_account_force_server_url:
        return _etebase_account_force_server_url(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_account_change_password:
        return _etebase_account_change_password(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_account_logout:
        return _etebase_account_logout(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_account_get_collection_manager:
        return _etebase_account_get_collection_manager(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_account_get_invitation_manager:
        return _etebase_account_get_invitation_manager(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_account_save:
        return _etebase_account_save(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_account_restore:
        return _etebase_account_restore(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_account_destroy:
        return _etebase_account_destroy(
          libEtebase,
          invocation,
          arena,
        );
      case #ETEBASE_UTILS_PRETTY_FINGERPRINT_SIZE:
        return _ETEBASE_UTILS_PRETTY_FINGERPRINT_SIZE(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_utils_randombytes:
        return _etebase_utils_randombytes(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_utils_pretty_fingerprint:
        return _etebase_utils_pretty_fingerprint(
          libEtebase,
          invocation,
          arena,
        );
      case #etebase_get_default_server_url:
        return _etebase_get_default_server_url(
          libEtebase,
          invocation,
          arena,
        );
      default:
        throw ArgumentError.value(
          invocation.method,
          'invocation.method',
          'Method does not exist',
        );
    }
  } finally {
    arena.releaseAll();
  }
}

_i1.MethodResult _etebase_user_profile_get_pubkey(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseUserProfile>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_user_profile_get_pubkey(this_);
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    _i7.TransferableTypedData.fromList([
      arena
          .attach(result)
          .cast<_i5.Uint8>()
          .asTypedList(libEtebase.etebase_user_profile_get_pubkey_size(this_))
    ]),
  );
}

_i1.MethodResult _etebase_user_profile_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseUserProfile>.fromAddress(
      (invocation.arguments[0] as int));
  libEtebase.etebase_user_profile_destroy(this_);
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_user_new(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final username = (invocation.arguments[0] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i5.Char>();
  final email = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i5.Char>();
  final result = libEtebase.etebase_user_new(
    username,
    email,
  );
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_user_set_username(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseUser>.fromAddress(
      (invocation.arguments[0] as int));
  final username = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i5.Char>();
  libEtebase.etebase_user_set_username(
    this_,
    username,
  );
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_user_get_username(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseUser>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_user_get_username(this_);
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    arena.attach(result).cast<_i8.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_user_set_email(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseUser>.fromAddress(
      (invocation.arguments[0] as int));
  final email = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i5.Char>();
  libEtebase.etebase_user_set_email(
    this_,
    email,
  );
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_user_get_email(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseUser>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_user_get_email(this_);
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    arena.attach(result).cast<_i8.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_user_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseUser>.fromAddress(
      (invocation.arguments[0] as int));
  libEtebase.etebase_user_destroy(this_);
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_signed_invitation_clone(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseSignedInvitation>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_signed_invitation_clone(this_);
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_signed_invitation_get_uid(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseSignedInvitation>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_signed_invitation_get_uid(this_);
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    arena.attach(result).cast<_i8.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_signed_invitation_get_username(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseSignedInvitation>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_signed_invitation_get_username(this_);
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    arena.attach(result).cast<_i8.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_signed_invitation_get_collection(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseSignedInvitation>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_signed_invitation_get_collection(this_);
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    arena.attach(result).cast<_i8.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_signed_invitation_get_access_level(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseSignedInvitation>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_signed_invitation_get_access_level(this_);
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    _i9.EtebaseCollectionAccessLevel.values[result],
  );
}

_i1.MethodResult _etebase_signed_invitation_get_from_username(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseSignedInvitation>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_signed_invitation_get_from_username(this_);
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    arena.attach(result).cast<_i8.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_signed_invitation_get_from_pubkey(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseSignedInvitation>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_signed_invitation_get_from_pubkey(this_);
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    _i7.TransferableTypedData.fromList([
      arena.attach(result).cast<_i5.Uint8>().asTypedList(
          libEtebase.etebase_signed_invitation_get_from_pubkey_size(this_))
    ]),
  );
}

_i1.MethodResult _etebase_signed_invitation_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseSignedInvitation>.fromAddress(
      (invocation.arguments[0] as int));
  libEtebase.etebase_signed_invitation_destroy(this_);
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_removed_collection_get_uid(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseRemovedCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_removed_collection_get_uid(this_);
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    arena.attach(result).cast<_i8.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_removed_collection_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseRemovedCollection>.fromAddress(
      (invocation.arguments[0] as int));
  libEtebase.etebase_removed_collection_destroy(this_);
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_invitation_list_response_get_iterator(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseInvitationListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  final result =
      libEtebase.etebase_invitation_list_response_get_iterator(this_);
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    arena.attach(result).cast<_i8.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_invitation_list_response_get_data(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseInvitationListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  final data_size =
      libEtebase.etebase_invitation_list_response_get_data_length(this_);
  final data = arena<_i5.Pointer<_i2.EtebaseSignedInvitation>>(data_size);
  final result = libEtebase.etebase_invitation_list_response_get_data(
    this_,
    data,
  );
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    _i6.FfiHelpers.extractPointerList(
      data,
      data_size,
      (p) => p.address,
    ),
  );
}

_i1.MethodResult _etebase_invitation_list_response_is_done(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseInvitationListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_invitation_list_response_is_done(this_);
  return _i1.MethodResult.success(
    invocation.id,
    result,
  );
}

_i1.MethodResult _etebase_invitation_list_response_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseInvitationListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  libEtebase.etebase_invitation_list_response_destroy(this_);
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_item_revisions_list_response_get_iterator(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemRevisionsListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  final result =
      libEtebase.etebase_item_revisions_list_response_get_iterator(this_);
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    arena.attach(result).cast<_i8.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_item_revisions_list_response_get_data(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemRevisionsListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  final data_size =
      libEtebase.etebase_item_revisions_list_response_get_data_length(this_);
  final data = arena<_i5.Pointer<_i2.EtebaseItem>>(data_size);
  final result = libEtebase.etebase_item_revisions_list_response_get_data(
    this_,
    data,
  );
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    _i6.FfiHelpers.extractPointerList(
      data,
      data_size,
      (p) => p.address,
    ),
  );
}

_i1.MethodResult _etebase_item_revisions_list_response_is_done(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemRevisionsListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_item_revisions_list_response_is_done(this_);
  return _i1.MethodResult.success(
    invocation.id,
    result,
  );
}

_i1.MethodResult _etebase_item_revisions_list_response_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemRevisionsListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  libEtebase.etebase_item_revisions_list_response_destroy(this_);
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_member_list_response_get_iterator(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseMemberListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_member_list_response_get_iterator(this_);
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    arena.attach(result).cast<_i8.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_member_list_response_get_data(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseMemberListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  final data_size =
      libEtebase.etebase_member_list_response_get_data_length(this_);
  final data = arena<_i5.Pointer<_i2.EtebaseCollectionMember>>(data_size);
  final result = libEtebase.etebase_member_list_response_get_data(
    this_,
    data,
  );
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    _i6.FfiHelpers.extractPointerList(
      data,
      data_size,
      (p) => p.address,
    ),
  );
}

_i1.MethodResult _etebase_member_list_response_is_done(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseMemberListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_member_list_response_is_done(this_);
  return _i1.MethodResult.success(
    invocation.id,
    result,
  );
}

_i1.MethodResult _etebase_member_list_response_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseMemberListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  libEtebase.etebase_member_list_response_destroy(this_);
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_item_metadata_new(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 0,
      'Invocation must have exactly 0 arguments');
  final result = libEtebase.etebase_item_metadata_new();
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_item_metadata_set_item_type(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemMetadata>.fromAddress(
      (invocation.arguments[0] as int));
  final itemType = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i5.Char>();
  libEtebase.etebase_item_metadata_set_item_type(
    this_,
    itemType,
  );
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_item_metadata_get_item_type(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemMetadata>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_item_metadata_get_item_type(this_);
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    arena.attach(result).cast<_i8.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_item_metadata_set_name(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemMetadata>.fromAddress(
      (invocation.arguments[0] as int));
  final name = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i5.Char>();
  libEtebase.etebase_item_metadata_set_name(
    this_,
    name,
  );
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_item_metadata_get_name(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemMetadata>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_item_metadata_get_name(this_);
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    arena.attach(result).cast<_i8.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_item_metadata_set_mtime(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemMetadata>.fromAddress(
      (invocation.arguments[0] as int));
  final mtime = arena<_i5.Int64>()
    ..value = (invocation.arguments[1] as DateTime).millisecondsSinceEpoch;
  libEtebase.etebase_item_metadata_set_mtime(
    this_,
    mtime,
  );
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_item_metadata_get_mtime(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemMetadata>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_item_metadata_get_mtime(this_);
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    DateTime.fromMillisecondsSinceEpoch(arena.attach(result).value),
  );
}

_i1.MethodResult _etebase_item_metadata_set_description(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemMetadata>.fromAddress(
      (invocation.arguments[0] as int));
  final description = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i5.Char>();
  libEtebase.etebase_item_metadata_set_description(
    this_,
    description,
  );
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_item_metadata_get_description(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemMetadata>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_item_metadata_get_description(this_);
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    arena.attach(result).cast<_i8.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_item_metadata_set_color(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemMetadata>.fromAddress(
      (invocation.arguments[0] as int));
  final color = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i5.Char>();
  libEtebase.etebase_item_metadata_set_color(
    this_,
    color,
  );
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_item_metadata_get_color(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemMetadata>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_item_metadata_get_color(this_);
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    arena.attach(result).cast<_i8.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_item_metadata_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemMetadata>.fromAddress(
      (invocation.arguments[0] as int));
  libEtebase.etebase_item_metadata_destroy(this_);
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_item_manager_fetch(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final itemUid = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i5.Char>();
  final fetchOptions_address = (invocation.arguments[2] as int?);
  final fetchOptions = fetchOptions_address == null
      ? _i5.nullptr
      : _i5.Pointer<_i2.EtebaseFetchOptions>.fromAddress(fetchOptions_address);
  final result = libEtebase.etebase_item_manager_fetch(
    this_,
    itemUid,
    fetchOptions,
  );
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_item_manager_create(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final meta = _i5.Pointer<_i2.EtebaseItemMetadata>.fromAddress(
      (invocation.arguments[1] as int));
  final content_buffer = (invocation.arguments[2] as _i7.TransferableTypedData)
      .materialize()
      .asUint8List();
  final content_size = content_buffer.length;
  final content = arena<_i5.Uint8>(content_size);
  content.asTypedList(content_size).setAll(
        0,
        content_buffer,
      );
  final result = libEtebase.etebase_item_manager_create(
    this_,
    meta,
    content.cast(),
    content_size,
  );
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_item_manager_create_raw(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final meta_buffer = (invocation.arguments[1] as _i7.TransferableTypedData)
      .materialize()
      .asUint8List();
  final meta_size = meta_buffer.length;
  final meta = arena<_i5.Uint8>(meta_size);
  meta.asTypedList(meta_size).setAll(
        0,
        meta_buffer,
      );
  final content_buffer = (invocation.arguments[2] as _i7.TransferableTypedData)
      .materialize()
      .asUint8List();
  final content_size = content_buffer.length;
  final content = arena<_i5.Uint8>(content_size);
  content.asTypedList(content_size).setAll(
        0,
        content_buffer,
      );
  final result = libEtebase.etebase_item_manager_create_raw(
    this_,
    meta.cast(),
    meta_size,
    content.cast(),
    content_size,
  );
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_item_manager_list(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final fetchOptions_address = (invocation.arguments[1] as int?);
  final fetchOptions = fetchOptions_address == null
      ? _i5.nullptr
      : _i5.Pointer<_i2.EtebaseFetchOptions>.fromAddress(fetchOptions_address);
  final result = libEtebase.etebase_item_manager_list(
    this_,
    fetchOptions,
  );
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_item_manager_item_revisions(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final item = _i5.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[1] as int));
  final fetchOptions_address = (invocation.arguments[2] as int?);
  final fetchOptions = fetchOptions_address == null
      ? _i5.nullptr
      : _i5.Pointer<_i2.EtebaseFetchOptions>.fromAddress(fetchOptions_address);
  final result = libEtebase.etebase_item_manager_item_revisions(
    this_,
    item,
    fetchOptions,
  );
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_item_manager_fetch_updates(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final items_size = (invocation.arguments[1] as List<int>).length;
  final items = arena<_i5.Pointer<_i2.EtebaseItem>>(items_size);
  _i6.FfiHelpers.assignPointerList(
    items,
    (invocation.arguments[1] as List<int>),
    _i5.Pointer<_i2.EtebaseItem>.fromAddress,
  );
  final fetchOptions_address = (invocation.arguments[2] as int?);
  final fetchOptions = fetchOptions_address == null
      ? _i5.nullptr
      : _i5.Pointer<_i2.EtebaseFetchOptions>.fromAddress(fetchOptions_address);
  final result = libEtebase.etebase_item_manager_fetch_updates(
    this_,
    items,
    items_size,
    fetchOptions,
  );
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_item_manager_fetch_multi(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final items_size = (invocation.arguments[1] as List<String>).length;
  final items = arena<_i5.Pointer<_i5.Char>>(items_size);
  _i6.FfiHelpers.assignPointerList(
    items,
    (invocation.arguments[1] as List<String>),
    (s) => s.toNativeUtf8(allocator: arena).cast<_i5.Char>(),
  );
  final fetchOptions_address = (invocation.arguments[2] as int?);
  final fetchOptions = fetchOptions_address == null
      ? _i5.nullptr
      : _i5.Pointer<_i2.EtebaseFetchOptions>.fromAddress(fetchOptions_address);
  final result = libEtebase.etebase_item_manager_fetch_multi(
    this_,
    items,
    items_size,
    fetchOptions,
  );
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_item_manager_batch(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final items_size = (invocation.arguments[1] as List<int>).length;
  final items = arena<_i5.Pointer<_i2.EtebaseItem>>(items_size);
  _i6.FfiHelpers.assignPointerList(
    items,
    (invocation.arguments[1] as List<int>),
    _i5.Pointer<_i2.EtebaseItem>.fromAddress,
  );
  final fetchOptions_address = (invocation.arguments[2] as int?);
  final fetchOptions = fetchOptions_address == null
      ? _i5.nullptr
      : _i5.Pointer<_i2.EtebaseFetchOptions>.fromAddress(fetchOptions_address);
  final result = libEtebase.etebase_item_manager_batch(
    this_,
    items,
    items_size,
    fetchOptions,
  );
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_item_manager_batch_deps(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 4,
      'Invocation must have exactly 4 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final items_size = (invocation.arguments[1] as List<int>).length;
  final items = arena<_i5.Pointer<_i2.EtebaseItem>>(items_size);
  _i6.FfiHelpers.assignPointerList(
    items,
    (invocation.arguments[1] as List<int>),
    _i5.Pointer<_i2.EtebaseItem>.fromAddress,
  );
  final deps_size = (invocation.arguments[2] as List<int>).length;
  final deps = arena<_i5.Pointer<_i2.EtebaseItem>>(deps_size);
  _i6.FfiHelpers.assignPointerList(
    deps,
    (invocation.arguments[2] as List<int>),
    _i5.Pointer<_i2.EtebaseItem>.fromAddress,
  );
  final fetchOptions_address = (invocation.arguments[3] as int?);
  final fetchOptions = fetchOptions_address == null
      ? _i5.nullptr
      : _i5.Pointer<_i2.EtebaseFetchOptions>.fromAddress(fetchOptions_address);
  final result = libEtebase.etebase_item_manager_batch_deps(
    this_,
    items,
    items_size,
    deps,
    deps_size,
    fetchOptions,
  );
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_item_manager_transaction(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final items_size = (invocation.arguments[1] as List<int>).length;
  final items = arena<_i5.Pointer<_i2.EtebaseItem>>(items_size);
  _i6.FfiHelpers.assignPointerList(
    items,
    (invocation.arguments[1] as List<int>),
    _i5.Pointer<_i2.EtebaseItem>.fromAddress,
  );
  final fetchOptions_address = (invocation.arguments[2] as int?);
  final fetchOptions = fetchOptions_address == null
      ? _i5.nullptr
      : _i5.Pointer<_i2.EtebaseFetchOptions>.fromAddress(fetchOptions_address);
  final result = libEtebase.etebase_item_manager_transaction(
    this_,
    items,
    items_size,
    fetchOptions,
  );
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_item_manager_transaction_deps(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 4,
      'Invocation must have exactly 4 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final items_size = (invocation.arguments[1] as List<int>).length;
  final items = arena<_i5.Pointer<_i2.EtebaseItem>>(items_size);
  _i6.FfiHelpers.assignPointerList(
    items,
    (invocation.arguments[1] as List<int>),
    _i5.Pointer<_i2.EtebaseItem>.fromAddress,
  );
  final deps_size = (invocation.arguments[2] as List<int>).length;
  final deps = arena<_i5.Pointer<_i2.EtebaseItem>>(deps_size);
  _i6.FfiHelpers.assignPointerList(
    deps,
    (invocation.arguments[2] as List<int>),
    _i5.Pointer<_i2.EtebaseItem>.fromAddress,
  );
  final fetchOptions_address = (invocation.arguments[3] as int?);
  final fetchOptions = fetchOptions_address == null
      ? _i5.nullptr
      : _i5.Pointer<_i2.EtebaseFetchOptions>.fromAddress(fetchOptions_address);
  final result = libEtebase.etebase_item_manager_transaction_deps(
    this_,
    items,
    items_size,
    deps,
    deps_size,
    fetchOptions,
  );
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_item_manager_cache_load(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final cached_buffer = (invocation.arguments[1] as _i7.TransferableTypedData)
      .materialize()
      .asUint8List();
  final cached_size = cached_buffer.length;
  final cached = arena<_i5.Uint8>(cached_size);
  cached.asTypedList(cached_size).setAll(
        0,
        cached_buffer,
      );
  final result = libEtebase.etebase_item_manager_cache_load(
    this_,
    cached.cast(),
    cached_size,
  );
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_item_manager_cache_save(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final item = _i5.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[1] as int));
  final retSize = arena<_i5.UnsignedLong>()..value = 0;
  final result = libEtebase.etebase_item_manager_cache_save(
    this_,
    item,
    retSize,
  );
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    _i7.TransferableTypedData.fromList(
        [arena.attach(result).cast<_i5.Uint8>().asTypedList(retSize.value)]),
  );
}

_i1.MethodResult _etebase_item_manager_cache_save_with_content(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final item = _i5.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[1] as int));
  final retSize = arena<_i5.UnsignedLong>()..value = 0;
  final result = libEtebase.etebase_item_manager_cache_save_with_content(
    this_,
    item,
    retSize,
  );
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    _i7.TransferableTypedData.fromList(
        [arena.attach(result).cast<_i5.Uint8>().asTypedList(retSize.value)]),
  );
}

_i1.MethodResult _etebase_item_manager_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  libEtebase.etebase_item_manager_destroy(this_);
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_item_list_response_get_stoken(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_item_list_response_get_stoken(this_);
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    arena.attach(result).cast<_i8.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_item_list_response_get_data(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  final data_size =
      libEtebase.etebase_item_list_response_get_data_length(this_);
  final data = arena<_i5.Pointer<_i2.EtebaseItem>>(data_size);
  final result = libEtebase.etebase_item_list_response_get_data(
    this_,
    data,
  );
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    _i6.FfiHelpers.extractPointerList(
      data,
      data_size,
      (p) => p.address,
    ),
  );
}

_i1.MethodResult _etebase_item_list_response_is_done(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_item_list_response_is_done(this_);
  return _i1.MethodResult.success(
    invocation.id,
    result,
  );
}

_i1.MethodResult _etebase_item_list_response_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  libEtebase.etebase_item_list_response_destroy(this_);
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_item_clone(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_item_clone(this_);
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_item_verify(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_item_verify(this_);
  return _i1.MethodResult.success(
    invocation.id,
    result,
  );
}

_i1.MethodResult _etebase_item_set_meta(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  final meta = _i5.Pointer<_i2.EtebaseItemMetadata>.fromAddress(
      (invocation.arguments[1] as int));
  final result = libEtebase.etebase_item_set_meta(
    this_,
    meta,
  );
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_item_get_meta(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_item_get_meta(this_);
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_item_set_meta_raw(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  final meta_buffer = (invocation.arguments[1] as _i7.TransferableTypedData)
      .materialize()
      .asUint8List();
  final meta_size = meta_buffer.length;
  final meta = arena<_i5.Uint8>(meta_size);
  meta.asTypedList(meta_size).setAll(
        0,
        meta_buffer,
      );
  final result = libEtebase.etebase_item_set_meta_raw(
    this_,
    meta.cast(),
    meta_size,
  );
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_item_get_meta_raw(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  final buf_size = (invocation.arguments[1] as int?) ?? 1024;
  final buf = arena<_i5.Uint8>(buf_size);
  final result = libEtebase.etebase_item_get_meta_raw(
    this_,
    buf.cast(),
    buf_size,
  );
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    _i7.TransferableTypedData.fromList(
        [buf.cast<_i5.Uint8>().asTypedList(buf_size)]),
  );
}

_i1.MethodResult _etebase_item_set_content(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  final content_buffer = (invocation.arguments[1] as _i7.TransferableTypedData)
      .materialize()
      .asUint8List();
  final content_size = content_buffer.length;
  final content = arena<_i5.Uint8>(content_size);
  content.asTypedList(content_size).setAll(
        0,
        content_buffer,
      );
  final result = libEtebase.etebase_item_set_content(
    this_,
    content.cast(),
    content_size,
  );
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_item_get_content(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  final buf_size = (invocation.arguments[1] as int?) ?? 1024;
  final buf = arena<_i5.Uint8>(buf_size);
  final result = libEtebase.etebase_item_get_content(
    this_,
    buf.cast(),
    buf_size,
  );
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    _i7.TransferableTypedData.fromList(
        [buf.cast<_i5.Uint8>().asTypedList(buf_size)]),
  );
}

_i1.MethodResult _etebase_item_delete(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_item_delete(this_);
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_item_is_deleted(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_item_is_deleted(this_);
  return _i1.MethodResult.success(
    invocation.id,
    result,
  );
}

_i1.MethodResult _etebase_item_get_uid(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_item_get_uid(this_);
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    arena.attach(result).cast<_i8.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_item_get_etag(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_item_get_etag(this_);
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    arena.attach(result).cast<_i8.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_item_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  libEtebase.etebase_item_destroy(this_);
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_fs_cache_new(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final path = (invocation.arguments[0] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i5.Char>();
  final username = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i5.Char>();
  final result = libEtebase.etebase_fs_cache_new(
    path,
    username,
  );
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_fs_cache_clear_user(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_fs_cache_clear_user(this_);
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_fs_cache_save_account(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final etebase = _i5.Pointer<_i2.EtebaseAccount>.fromAddress(
      (invocation.arguments[1] as int));
  final encryptionKey_buffer =
      (invocation.arguments[2] as _i7.TransferableTypedData?)
          ?.materialize()
          .asUint8List();
  final encryptionKey_size = encryptionKey_buffer?.length ?? 0;
  final encryptionKey = encryptionKey_buffer == null
      ? _i5.nullptr
      : arena<_i5.Uint8>(encryptionKey_size);
  if (encryptionKey_buffer != null) {
    encryptionKey.asTypedList(encryptionKey_size).setAll(
          0,
          encryptionKey_buffer,
        );
  }
  final result = libEtebase.etebase_fs_cache_save_account(
    this_,
    etebase,
    encryptionKey.cast(),
    encryptionKey_size,
  );
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_fs_cache_load_account(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final client = _i5.Pointer<_i2.EtebaseClient>.fromAddress(
      (invocation.arguments[1] as int));
  final encryptionKey_buffer =
      (invocation.arguments[2] as _i7.TransferableTypedData?)
          ?.materialize()
          .asUint8List();
  final encryptionKey_size = encryptionKey_buffer?.length ?? 0;
  final encryptionKey = encryptionKey_buffer == null
      ? _i5.nullptr
      : arena<_i5.Uint8>(encryptionKey_size);
  if (encryptionKey_buffer != null) {
    encryptionKey.asTypedList(encryptionKey_size).setAll(
          0,
          encryptionKey_buffer,
        );
  }
  final result = libEtebase.etebase_fs_cache_load_account(
    this_,
    client,
    encryptionKey.cast(),
    encryptionKey_size,
  );
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_fs_cache_save_stoken(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final stoken = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i5.Char>();
  final result = libEtebase.etebase_fs_cache_save_stoken(
    this_,
    stoken,
  );
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_fs_cache_load_stoken(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_fs_cache_load_stoken(this_);
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    arena.attach(result).cast<_i8.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_fs_cache_collection_save_stoken(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final colUid = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i5.Char>();
  final stoken = (invocation.arguments[2] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i5.Char>();
  final result = libEtebase.etebase_fs_cache_collection_save_stoken(
    this_,
    colUid,
    stoken,
  );
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_fs_cache_collection_load_stoken(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final colUid = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i5.Char>();
  final result = libEtebase.etebase_fs_cache_collection_load_stoken(
    this_,
    colUid,
  );
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    arena.attach(result).cast<_i8.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_fs_cache_collection_set(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final colMgr = _i5.Pointer<_i2.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[1] as int));
  final col = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[2] as int));
  final result = libEtebase.etebase_fs_cache_collection_set(
    this_,
    colMgr,
    col,
  );
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_fs_cache_collection_unset(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final colMgr = _i5.Pointer<_i2.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[1] as int));
  final colUid = (invocation.arguments[2] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i5.Char>();
  final result = libEtebase.etebase_fs_cache_collection_unset(
    this_,
    colMgr,
    colUid,
  );
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_fs_cache_collection_get(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final colMgr = _i5.Pointer<_i2.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[1] as int));
  final colUid = (invocation.arguments[2] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i5.Char>();
  final result = libEtebase.etebase_fs_cache_collection_get(
    this_,
    colMgr,
    colUid,
  );
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_fs_cache_item_set(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 4,
      'Invocation must have exactly 4 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final itemMgr = _i5.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[1] as int));
  final colUid = (invocation.arguments[2] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i5.Char>();
  final item = _i5.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[3] as int));
  final result = libEtebase.etebase_fs_cache_item_set(
    this_,
    itemMgr,
    colUid,
    item,
  );
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_fs_cache_item_unset(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 4,
      'Invocation must have exactly 4 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final itemMgr = _i5.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[1] as int));
  final colUid = (invocation.arguments[2] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i5.Char>();
  final itemUid = (invocation.arguments[3] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i5.Char>();
  final result = libEtebase.etebase_fs_cache_item_unset(
    this_,
    itemMgr,
    colUid,
    itemUid,
  );
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_fs_cache_item_get(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 4,
      'Invocation must have exactly 4 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final itemMgr = _i5.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[1] as int));
  final colUid = (invocation.arguments[2] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i5.Char>();
  final itemUid = (invocation.arguments[3] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i5.Char>();
  final result = libEtebase.etebase_fs_cache_item_get(
    this_,
    itemMgr,
    colUid,
    itemUid,
  );
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_fs_cache_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  libEtebase.etebase_fs_cache_destroy(this_);
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_fetch_options_new(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 0,
      'Invocation must have exactly 0 arguments');
  final result = libEtebase.etebase_fetch_options_new();
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_fetch_options_set_limit(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseFetchOptions>.fromAddress(
      (invocation.arguments[0] as int));
  final limit = (invocation.arguments[1] as int);
  libEtebase.etebase_fetch_options_set_limit(
    this_,
    limit,
  );
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_fetch_options_set_prefetch(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseFetchOptions>.fromAddress(
      (invocation.arguments[0] as int));
  final prefetch =
      (invocation.arguments[1] as _i10.EtebasePrefetchOption).index;
  libEtebase.etebase_fetch_options_set_prefetch(
    this_,
    prefetch,
  );
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_fetch_options_set_with_collection(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseFetchOptions>.fromAddress(
      (invocation.arguments[0] as int));
  final withCollection = (invocation.arguments[1] as bool);
  libEtebase.etebase_fetch_options_set_with_collection(
    this_,
    withCollection,
  );
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_fetch_options_set_iterator(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseFetchOptions>.fromAddress(
      (invocation.arguments[0] as int));
  final iterator = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i5.Char>();
  libEtebase.etebase_fetch_options_set_iterator(
    this_,
    iterator,
  );
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_fetch_options_set_stoken(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseFetchOptions>.fromAddress(
      (invocation.arguments[0] as int));
  final stoken = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i5.Char>();
  libEtebase.etebase_fetch_options_set_stoken(
    this_,
    stoken,
  );
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_fetch_options_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseFetchOptions>.fromAddress(
      (invocation.arguments[0] as int));
  libEtebase.etebase_fetch_options_destroy(this_);
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_collection_member_manager_list(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionMemberManager>.fromAddress(
      (invocation.arguments[0] as int));
  final fetchOptions_address = (invocation.arguments[1] as int?);
  final fetchOptions = fetchOptions_address == null
      ? _i5.nullptr
      : _i5.Pointer<_i2.EtebaseFetchOptions>.fromAddress(fetchOptions_address);
  final result = libEtebase.etebase_collection_member_manager_list(
    this_,
    fetchOptions,
  );
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_collection_member_manager_remove(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionMemberManager>.fromAddress(
      (invocation.arguments[0] as int));
  final username = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i5.Char>();
  final result = libEtebase.etebase_collection_member_manager_remove(
    this_,
    username,
  );
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_collection_member_manager_leave(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionMemberManager>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_member_manager_leave(this_);
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_collection_member_manager_modify_access_level(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionMemberManager>.fromAddress(
      (invocation.arguments[0] as int));
  final username = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i5.Char>();
  final accessLevel =
      (invocation.arguments[2] as _i9.EtebaseCollectionAccessLevel).index;
  final result =
      libEtebase.etebase_collection_member_manager_modify_access_level(
    this_,
    username,
    accessLevel,
  );
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_collection_member_manager_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionMemberManager>.fromAddress(
      (invocation.arguments[0] as int));
  libEtebase.etebase_collection_member_manager_destroy(this_);
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_collection_member_clone(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionMember>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_member_clone(this_);
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_collection_member_get_username(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionMember>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_member_get_username(this_);
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    arena.attach(result).cast<_i8.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_collection_member_get_access_level(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionMember>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_member_get_access_level(this_);
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    _i9.EtebaseCollectionAccessLevel.values[result],
  );
}

_i1.MethodResult _etebase_collection_member_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionMember>.fromAddress(
      (invocation.arguments[0] as int));
  libEtebase.etebase_collection_member_destroy(this_);
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_collection_manager_fetch(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  final colUid = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i5.Char>();
  final fetchOptions_address = (invocation.arguments[2] as int?);
  final fetchOptions = fetchOptions_address == null
      ? _i5.nullptr
      : _i5.Pointer<_i2.EtebaseFetchOptions>.fromAddress(fetchOptions_address);
  final result = libEtebase.etebase_collection_manager_fetch(
    this_,
    colUid,
    fetchOptions,
  );
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_collection_manager_create(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 4,
      'Invocation must have exactly 4 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  final collectionType = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i5.Char>();
  final meta = _i5.Pointer<_i2.EtebaseItemMetadata>.fromAddress(
      (invocation.arguments[2] as int));
  final content_buffer = (invocation.arguments[3] as _i7.TransferableTypedData)
      .materialize()
      .asUint8List();
  final content_size = content_buffer.length;
  final content = arena<_i5.Uint8>(content_size);
  content.asTypedList(content_size).setAll(
        0,
        content_buffer,
      );
  final result = libEtebase.etebase_collection_manager_create(
    this_,
    collectionType,
    meta,
    content.cast(),
    content_size,
  );
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_collection_manager_create_raw(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 4,
      'Invocation must have exactly 4 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  final collectionType = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i5.Char>();
  final meta_buffer = (invocation.arguments[2] as _i7.TransferableTypedData)
      .materialize()
      .asUint8List();
  final meta_size = meta_buffer.length;
  final meta = arena<_i5.Uint8>(meta_size);
  meta.asTypedList(meta_size).setAll(
        0,
        meta_buffer,
      );
  final content_buffer = (invocation.arguments[3] as _i7.TransferableTypedData)
      .materialize()
      .asUint8List();
  final content_size = content_buffer.length;
  final content = arena<_i5.Uint8>(content_size);
  content.asTypedList(content_size).setAll(
        0,
        content_buffer,
      );
  final result = libEtebase.etebase_collection_manager_create_raw(
    this_,
    collectionType,
    meta.cast(),
    meta_size,
    content.cast(),
    content_size,
  );
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_collection_manager_get_item_manager(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  final col = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[1] as int));
  final result = libEtebase.etebase_collection_manager_get_item_manager(
    this_,
    col,
  );
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_collection_manager_list(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  final collectionType = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i5.Char>();
  final fetchOptions_address = (invocation.arguments[2] as int?);
  final fetchOptions = fetchOptions_address == null
      ? _i5.nullptr
      : _i5.Pointer<_i2.EtebaseFetchOptions>.fromAddress(fetchOptions_address);
  final result = libEtebase.etebase_collection_manager_list(
    this_,
    collectionType,
    fetchOptions,
  );
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_collection_manager_list_multi(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  final collectionTypes_size = (invocation.arguments[1] as List<String>).length;
  final collectionTypes = arena<_i5.Pointer<_i5.Char>>(collectionTypes_size);
  _i6.FfiHelpers.assignPointerList(
    collectionTypes,
    (invocation.arguments[1] as List<String>),
    (s) => s.toNativeUtf8(allocator: arena).cast<_i5.Char>(),
  );
  final fetchOptions_address = (invocation.arguments[2] as int?);
  final fetchOptions = fetchOptions_address == null
      ? _i5.nullptr
      : _i5.Pointer<_i2.EtebaseFetchOptions>.fromAddress(fetchOptions_address);
  final result = libEtebase.etebase_collection_manager_list_multi(
    this_,
    collectionTypes,
    collectionTypes_size,
    fetchOptions,
  );
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_collection_manager_upload(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  final collection = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[1] as int));
  final fetchOptions_address = (invocation.arguments[2] as int?);
  final fetchOptions = fetchOptions_address == null
      ? _i5.nullptr
      : _i5.Pointer<_i2.EtebaseFetchOptions>.fromAddress(fetchOptions_address);
  final result = libEtebase.etebase_collection_manager_upload(
    this_,
    collection,
    fetchOptions,
  );
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_collection_manager_transaction(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  final collection = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[1] as int));
  final fetchOptions_address = (invocation.arguments[2] as int?);
  final fetchOptions = fetchOptions_address == null
      ? _i5.nullptr
      : _i5.Pointer<_i2.EtebaseFetchOptions>.fromAddress(fetchOptions_address);
  final result = libEtebase.etebase_collection_manager_transaction(
    this_,
    collection,
    fetchOptions,
  );
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_collection_manager_cache_load(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  final cached_buffer = (invocation.arguments[1] as _i7.TransferableTypedData)
      .materialize()
      .asUint8List();
  final cached_size = cached_buffer.length;
  final cached = arena<_i5.Uint8>(cached_size);
  cached.asTypedList(cached_size).setAll(
        0,
        cached_buffer,
      );
  final result = libEtebase.etebase_collection_manager_cache_load(
    this_,
    cached.cast(),
    cached_size,
  );
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_collection_manager_cache_save(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  final collection = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[1] as int));
  final retSize = arena<_i5.UnsignedLong>()..value = 0;
  final result = libEtebase.etebase_collection_manager_cache_save(
    this_,
    collection,
    retSize,
  );
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    _i7.TransferableTypedData.fromList(
        [arena.attach(result).cast<_i5.Uint8>().asTypedList(retSize.value)]),
  );
}

_i1.MethodResult _etebase_collection_manager_cache_save_with_content(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  final collection = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[1] as int));
  final retSize = arena<_i5.UnsignedLong>()..value = 0;
  final result = libEtebase.etebase_collection_manager_cache_save_with_content(
    this_,
    collection,
    retSize,
  );
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    _i7.TransferableTypedData.fromList(
        [arena.attach(result).cast<_i5.Uint8>().asTypedList(retSize.value)]),
  );
}

_i1.MethodResult _etebase_collection_manager_get_member_manager(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  final col = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[1] as int));
  final result = libEtebase.etebase_collection_manager_get_member_manager(
    this_,
    col,
  );
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_collection_manager_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  libEtebase.etebase_collection_manager_destroy(this_);
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_collection_list_response_get_stoken(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_list_response_get_stoken(this_);
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    arena.attach(result).cast<_i8.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_collection_list_response_get_data(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  final data_size =
      libEtebase.etebase_collection_list_response_get_data_length(this_);
  final data = arena<_i5.Pointer<_i2.EtebaseCollection>>(data_size);
  final result = libEtebase.etebase_collection_list_response_get_data(
    this_,
    data,
  );
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    _i6.FfiHelpers.extractPointerList(
      data,
      data_size,
      (p) => p.address,
    ),
  );
}

_i1.MethodResult _etebase_collection_list_response_is_done(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_list_response_is_done(this_);
  return _i1.MethodResult.success(
    invocation.id,
    result,
  );
}

_i1.MethodResult _etebase_collection_list_response_get_removed_memberships(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  final data_size = libEtebase
      .etebase_collection_list_response_get_removed_memberships_length(this_);
  final data = arena<_i5.Pointer<_i2.EtebaseRemovedCollection>>(data_size);
  final result =
      libEtebase.etebase_collection_list_response_get_removed_memberships(
    this_,
    data,
  );
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    _i6.FfiHelpers.extractPointerList(
      data,
      data_size,
      (p) => p.address,
    ),
  );
}

_i1.MethodResult _etebase_collection_list_response_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  libEtebase.etebase_collection_list_response_destroy(this_);
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_invitation_manager_list_incoming(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionInvitationManager>.fromAddress(
      (invocation.arguments[0] as int));
  final fetchOptions_address = (invocation.arguments[1] as int?);
  final fetchOptions = fetchOptions_address == null
      ? _i5.nullptr
      : _i5.Pointer<_i2.EtebaseFetchOptions>.fromAddress(fetchOptions_address);
  final result = libEtebase.etebase_invitation_manager_list_incoming(
    this_,
    fetchOptions,
  );
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_invitation_manager_list_outgoing(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionInvitationManager>.fromAddress(
      (invocation.arguments[0] as int));
  final fetchOptions_address = (invocation.arguments[1] as int?);
  final fetchOptions = fetchOptions_address == null
      ? _i5.nullptr
      : _i5.Pointer<_i2.EtebaseFetchOptions>.fromAddress(fetchOptions_address);
  final result = libEtebase.etebase_invitation_manager_list_outgoing(
    this_,
    fetchOptions,
  );
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_invitation_manager_accept(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionInvitationManager>.fromAddress(
      (invocation.arguments[0] as int));
  final invitation = _i5.Pointer<_i2.EtebaseSignedInvitation>.fromAddress(
      (invocation.arguments[1] as int));
  final result = libEtebase.etebase_invitation_manager_accept(
    this_,
    invitation,
  );
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_invitation_manager_reject(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionInvitationManager>.fromAddress(
      (invocation.arguments[0] as int));
  final invitation = _i5.Pointer<_i2.EtebaseSignedInvitation>.fromAddress(
      (invocation.arguments[1] as int));
  final result = libEtebase.etebase_invitation_manager_reject(
    this_,
    invitation,
  );
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_invitation_manager_fetch_user_profile(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionInvitationManager>.fromAddress(
      (invocation.arguments[0] as int));
  final username = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i5.Char>();
  final result = libEtebase.etebase_invitation_manager_fetch_user_profile(
    this_,
    username,
  );
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_invitation_manager_invite(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 5,
      'Invocation must have exactly 5 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionInvitationManager>.fromAddress(
      (invocation.arguments[0] as int));
  final collection = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[1] as int));
  final username = (invocation.arguments[2] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i5.Char>();
  final pubkey_buffer = (invocation.arguments[3] as _i7.TransferableTypedData)
      .materialize()
      .asUint8List();
  final pubkey_size = pubkey_buffer.length;
  final pubkey = arena<_i5.Uint8>(pubkey_size);
  pubkey.asTypedList(pubkey_size).setAll(
        0,
        pubkey_buffer,
      );
  final accessLevel =
      (invocation.arguments[4] as _i9.EtebaseCollectionAccessLevel).index;
  final result = libEtebase.etebase_invitation_manager_invite(
    this_,
    collection,
    username,
    pubkey.cast(),
    pubkey_size,
    accessLevel,
  );
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_invitation_manager_disinvite(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionInvitationManager>.fromAddress(
      (invocation.arguments[0] as int));
  final invitation = _i5.Pointer<_i2.EtebaseSignedInvitation>.fromAddress(
      (invocation.arguments[1] as int));
  final result = libEtebase.etebase_invitation_manager_disinvite(
    this_,
    invitation,
  );
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_invitation_manager_get_pubkey(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionInvitationManager>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_invitation_manager_get_pubkey(this_);
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    _i7.TransferableTypedData.fromList([
      arena.attach(result).cast<_i5.Uint8>().asTypedList(
          libEtebase.etebase_invitation_manager_get_pubkey_size(this_))
    ]),
  );
}

_i1.MethodResult _etebase_invitation_manager_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionInvitationManager>.fromAddress(
      (invocation.arguments[0] as int));
  libEtebase.etebase_invitation_manager_destroy(this_);
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_collection_clone(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_clone(this_);
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_collection_verify(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_verify(this_);
  return _i1.MethodResult.success(
    invocation.id,
    result,
  );
}

_i1.MethodResult _etebase_collection_set_meta(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final meta = _i5.Pointer<_i2.EtebaseItemMetadata>.fromAddress(
      (invocation.arguments[1] as int));
  final result = libEtebase.etebase_collection_set_meta(
    this_,
    meta,
  );
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_collection_get_meta(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_get_meta(this_);
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_collection_set_meta_raw(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final meta_buffer = (invocation.arguments[1] as _i7.TransferableTypedData)
      .materialize()
      .asUint8List();
  final meta_size = meta_buffer.length;
  final meta = arena<_i5.Uint8>(meta_size);
  meta.asTypedList(meta_size).setAll(
        0,
        meta_buffer,
      );
  final result = libEtebase.etebase_collection_set_meta_raw(
    this_,
    meta.cast(),
    meta_size,
  );
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_collection_get_meta_raw(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final buf_size = (invocation.arguments[1] as int?) ?? 1024;
  final buf = arena<_i5.Uint8>(buf_size);
  final result = libEtebase.etebase_collection_get_meta_raw(
    this_,
    buf.cast(),
    buf_size,
  );
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    _i7.TransferableTypedData.fromList(
        [buf.cast<_i5.Uint8>().asTypedList(buf_size)]),
  );
}

_i1.MethodResult _etebase_collection_set_content(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final content_buffer = (invocation.arguments[1] as _i7.TransferableTypedData)
      .materialize()
      .asUint8List();
  final content_size = content_buffer.length;
  final content = arena<_i5.Uint8>(content_size);
  content.asTypedList(content_size).setAll(
        0,
        content_buffer,
      );
  final result = libEtebase.etebase_collection_set_content(
    this_,
    content.cast(),
    content_size,
  );
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_collection_get_content(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final buf_size = (invocation.arguments[1] as int?) ?? 1024;
  final buf = arena<_i5.Uint8>(buf_size);
  final result = libEtebase.etebase_collection_get_content(
    this_,
    buf.cast(),
    buf_size,
  );
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    _i7.TransferableTypedData.fromList(
        [buf.cast<_i5.Uint8>().asTypedList(buf_size)]),
  );
}

_i1.MethodResult _etebase_collection_delete(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_delete(this_);
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_collection_is_deleted(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_is_deleted(this_);
  return _i1.MethodResult.success(
    invocation.id,
    result,
  );
}

_i1.MethodResult _etebase_collection_get_uid(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_get_uid(this_);
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    arena.attach(result).cast<_i8.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_collection_get_etag(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_get_etag(this_);
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    arena.attach(result).cast<_i8.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_collection_get_stoken(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_get_stoken(this_);
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    arena.attach(result).cast<_i8.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_collection_as_item(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_as_item(this_);
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_collection_get_collection_type(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_get_collection_type(this_);
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    arena.attach(result).cast<_i8.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_collection_get_access_level(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_get_access_level(this_);
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    _i9.EtebaseCollectionAccessLevel.values[result],
  );
}

_i1.MethodResult _etebase_collection_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  libEtebase.etebase_collection_destroy(this_);
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_client_new(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final clientName = (invocation.arguments[0] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i5.Char>();
  final serverUrl = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i5.Char>();
  final result = libEtebase.etebase_client_new(
    clientName,
    serverUrl,
  );
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_client_set_server_url(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseClient>.fromAddress(
      (invocation.arguments[0] as int));
  final serverUrl = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i5.Char>();
  final result = libEtebase.etebase_client_set_server_url(
    this_,
    serverUrl,
  );
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_client_check_etebase_server(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final client = _i5.Pointer<_i2.EtebaseClient>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_client_check_etebase_server(client);
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    result == 0 ? false : true,
  );
}

_i1.MethodResult _etebase_client_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseClient>.fromAddress(
      (invocation.arguments[0] as int));
  libEtebase.etebase_client_destroy(this_);
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_account_login(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  final client = _i5.Pointer<_i2.EtebaseClient>.fromAddress(
      (invocation.arguments[0] as int));
  final username = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i5.Char>();
  final password = (invocation.arguments[2] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i5.Char>();
  final result = libEtebase.etebase_account_login(
    client,
    username,
    password,
  );
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_account_signup(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  final client = _i5.Pointer<_i2.EtebaseClient>.fromAddress(
      (invocation.arguments[0] as int));
  final user = _i5.Pointer<_i2.EtebaseUser>.fromAddress(
      (invocation.arguments[1] as int));
  final password = (invocation.arguments[2] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i5.Char>();
  final result = libEtebase.etebase_account_signup(
    client,
    user,
    password,
  );
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_account_fetch_token(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseAccount>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_account_fetch_token(this_);
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_account_fetch_dashboard_url(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseAccount>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_account_fetch_dashboard_url(this_);
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    arena.attach(result).cast<_i8.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_account_force_server_url(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseAccount>.fromAddress(
      (invocation.arguments[0] as int));
  final serverUrl = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i5.Char>();
  final result = libEtebase.etebase_account_force_server_url(
    this_,
    serverUrl,
  );
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_account_change_password(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseAccount>.fromAddress(
      (invocation.arguments[0] as int));
  final password = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i5.Char>();
  final result = libEtebase.etebase_account_change_password(
    this_,
    password,
  );
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_account_logout(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseAccount>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_account_logout(this_);
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_account_get_collection_manager(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseAccount>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_account_get_collection_manager(this_);
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_account_get_invitation_manager(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseAccount>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_account_get_invitation_manager(this_);
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_account_save(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseAccount>.fromAddress(
      (invocation.arguments[0] as int));
  final encryptionKey_buffer =
      (invocation.arguments[1] as _i7.TransferableTypedData?)
          ?.materialize()
          .asUint8List();
  final encryptionKey_size = encryptionKey_buffer?.length ?? 0;
  final encryptionKey = encryptionKey_buffer == null
      ? _i5.nullptr
      : arena<_i5.Uint8>(encryptionKey_size);
  if (encryptionKey_buffer != null) {
    encryptionKey.asTypedList(encryptionKey_size).setAll(
          0,
          encryptionKey_buffer,
        );
  }
  final result = libEtebase.etebase_account_save(
    this_,
    encryptionKey.cast(),
    encryptionKey_size,
  );
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    arena.attach(result).cast<_i8.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_account_restore(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  final client = _i5.Pointer<_i2.EtebaseClient>.fromAddress(
      (invocation.arguments[0] as int));
  final accountDataStored = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i5.Char>();
  final encryptionKey_buffer =
      (invocation.arguments[2] as _i7.TransferableTypedData?)
          ?.materialize()
          .asUint8List();
  final encryptionKey_size = encryptionKey_buffer?.length ?? 0;
  final encryptionKey = encryptionKey_buffer == null
      ? _i5.nullptr
      : arena<_i5.Uint8>(encryptionKey_size);
  if (encryptionKey_buffer != null) {
    encryptionKey.asTypedList(encryptionKey_size).setAll(
          0,
          encryptionKey_buffer,
        );
  }
  final result = libEtebase.etebase_account_restore(
    client,
    accountDataStored,
    encryptionKey.cast(),
    encryptionKey_size,
  );
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_account_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseAccount>.fromAddress(
      (invocation.arguments[0] as int));
  libEtebase.etebase_account_destroy(this_);
  return _i1.MethodResult.success(
    invocation.id,
    null,
  );
}

_i1.MethodResult _ETEBASE_UTILS_PRETTY_FINGERPRINT_SIZE(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 0,
      'Invocation must have exactly 0 arguments');
  final result = libEtebase.ETEBASE_UTILS_PRETTY_FINGERPRINT_SIZE;
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    result,
  );
}

_i1.MethodResult _etebase_utils_randombytes(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final size = (invocation.arguments[0] as int);
  final buf = arena<_i5.Uint8>(size);
  final result = libEtebase.etebase_utils_randombytes(
    buf.cast(),
    size,
  );
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    _i7.TransferableTypedData.fromList(
        [buf.cast<_i5.Uint8>().asTypedList(size)]),
  );
}

_i1.MethodResult _etebase_utils_pretty_fingerprint(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final content_buffer = (invocation.arguments[0] as _i7.TransferableTypedData)
      .materialize()
      .asUint8List();
  final content_size = content_buffer.length;
  final content = arena<_i5.Uint8>(content_size);
  content.asTypedList(content_size).setAll(
        0,
        content_buffer,
      );
  final buf = arena<_i5.Char>(libEtebase.ETEBASE_UTILS_PRETTY_FINGERPRINT_SIZE);
  final result = libEtebase.etebase_utils_pretty_fingerprint(
    content.cast(),
    content_size,
    buf,
  );
  if (result == -1) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    buf
        .cast<_i8.Utf8>()
        .toDartString(length: libEtebase.ETEBASE_UTILS_PRETTY_FINGERPRINT_SIZE),
  );
}

_i1.MethodResult _etebase_get_default_server_url(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i4.EtebaseArena arena,
) {
  assert(invocation.arguments.length == 0,
      'Invocation must have exactly 0 arguments');
  final result = libEtebase.etebase_get_default_server_url();
  if (result == _i5.nullptr) {
    return _i6.FfiHelpers.errorResult(
      libEtebase,
      arena,
      invocation.id,
    );
  }
  return _i1.MethodResult.success(
    invocation.id,
    arena.attach(result).cast<_i8.Utf8>().toDartString(),
  );
}
