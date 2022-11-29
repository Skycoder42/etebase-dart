// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// EtebaseIsolateGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, require_trailing_commas, unnecessary_parenthesis, prefer_relative_imports, lines_longer_than_80_chars, prefer_is_empty, constant_identifier_names, avoid_bool_literals_in_conditional_expressions
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:ffi' as _i6;
import 'dart:isolate' as _i8;

import 'package:etebase/gen/ffi/libetebase.ffi.dart' as _i2;
import 'package:etebase/src/isolate/ffi_helpers.dart' as _i7;
import 'package:etebase/src/isolate/method_invocation.dart' as _i4;
import 'package:etebase/src/isolate/method_result.dart' as _i1;
import 'package:etebase/src/model/etebase_collection_access_level.dart' as _i9;
import 'package:etebase/src/model/etebase_config.dart' as _i3;
import 'package:etebase/src/model/etebase_error_code.dart' as _i10;
import 'package:etebase/src/model/etebase_prefetch_option.dart' as _i11;
import 'package:ffi/ffi.dart' as _i5;
import 'package:ffi/ffi.dart';

_i1.MethodResult etebaseIsolateMessageHandler(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
) {
  final arena = _i5.Arena();
  try {
    switch (invocation.method) {
      case #etebase_user_profile_get_pubkey:
        return _etebase_user_profile_get_pubkey(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_user_profile_destroy:
        return _etebase_user_profile_destroy(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_user_new:
        return _etebase_user_new(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_user_set_username:
        return _etebase_user_set_username(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_user_get_username:
        return _etebase_user_get_username(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_user_set_email:
        return _etebase_user_set_email(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_user_get_email:
        return _etebase_user_get_email(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_user_destroy:
        return _etebase_user_destroy(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_signed_invitation_clone:
        return _etebase_signed_invitation_clone(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_signed_invitation_get_uid:
        return _etebase_signed_invitation_get_uid(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_signed_invitation_get_username:
        return _etebase_signed_invitation_get_username(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_signed_invitation_get_collection:
        return _etebase_signed_invitation_get_collection(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_signed_invitation_get_access_level:
        return _etebase_signed_invitation_get_access_level(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_signed_invitation_get_from_username:
        return _etebase_signed_invitation_get_from_username(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_signed_invitation_get_from_pubkey:
        return _etebase_signed_invitation_get_from_pubkey(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_signed_invitation_destroy:
        return _etebase_signed_invitation_destroy(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_removed_collection_get_uid:
        return _etebase_removed_collection_get_uid(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_removed_collection_destroy:
        return _etebase_removed_collection_destroy(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_invitation_list_response_get_iterator:
        return _etebase_invitation_list_response_get_iterator(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_invitation_list_response_get_data:
        return _etebase_invitation_list_response_get_data(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_invitation_list_response_is_done:
        return _etebase_invitation_list_response_is_done(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_invitation_list_response_destroy:
        return _etebase_invitation_list_response_destroy(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_item_revisions_list_response_get_iterator:
        return _etebase_item_revisions_list_response_get_iterator(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_item_revisions_list_response_get_data:
        return _etebase_item_revisions_list_response_get_data(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_item_revisions_list_response_is_done:
        return _etebase_item_revisions_list_response_is_done(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_item_revisions_list_response_destroy:
        return _etebase_item_revisions_list_response_destroy(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_member_list_response_get_iterator:
        return _etebase_member_list_response_get_iterator(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_member_list_response_get_data:
        return _etebase_member_list_response_get_data(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_member_list_response_is_done:
        return _etebase_member_list_response_is_done(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_member_list_response_destroy:
        return _etebase_member_list_response_destroy(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_item_metadata_new:
        return _etebase_item_metadata_new(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_item_metadata_set_item_type:
        return _etebase_item_metadata_set_item_type(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_item_metadata_get_item_type:
        return _etebase_item_metadata_get_item_type(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_item_metadata_set_name:
        return _etebase_item_metadata_set_name(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_item_metadata_get_name:
        return _etebase_item_metadata_get_name(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_item_metadata_set_mtime:
        return _etebase_item_metadata_set_mtime(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_item_metadata_get_mtime:
        return _etebase_item_metadata_get_mtime(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_item_metadata_set_description:
        return _etebase_item_metadata_set_description(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_item_metadata_get_description:
        return _etebase_item_metadata_get_description(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_item_metadata_set_color:
        return _etebase_item_metadata_set_color(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_item_metadata_get_color:
        return _etebase_item_metadata_get_color(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_item_metadata_destroy:
        return _etebase_item_metadata_destroy(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_item_manager_fetch:
        return _etebase_item_manager_fetch(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_item_manager_create:
        return _etebase_item_manager_create(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_item_manager_create_raw:
        return _etebase_item_manager_create_raw(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_item_manager_list:
        return _etebase_item_manager_list(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_item_manager_item_revisions:
        return _etebase_item_manager_item_revisions(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_item_manager_fetch_updates:
        return _etebase_item_manager_fetch_updates(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_item_manager_fetch_multi:
        return _etebase_item_manager_fetch_multi(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_item_manager_batch:
        return _etebase_item_manager_batch(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_item_manager_batch_deps:
        return _etebase_item_manager_batch_deps(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_item_manager_transaction:
        return _etebase_item_manager_transaction(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_item_manager_transaction_deps:
        return _etebase_item_manager_transaction_deps(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_item_manager_cache_load:
        return _etebase_item_manager_cache_load(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_item_manager_cache_save:
        return _etebase_item_manager_cache_save(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_item_manager_cache_save_with_content:
        return _etebase_item_manager_cache_save_with_content(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_item_manager_destroy:
        return _etebase_item_manager_destroy(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_item_list_response_get_stoken:
        return _etebase_item_list_response_get_stoken(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_item_list_response_get_data:
        return _etebase_item_list_response_get_data(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_item_list_response_is_done:
        return _etebase_item_list_response_is_done(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_item_list_response_destroy:
        return _etebase_item_list_response_destroy(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_item_clone:
        return _etebase_item_clone(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_item_verify:
        return _etebase_item_verify(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_item_set_meta:
        return _etebase_item_set_meta(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_item_get_meta:
        return _etebase_item_get_meta(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_item_set_meta_raw:
        return _etebase_item_set_meta_raw(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_item_get_meta_raw:
        return _etebase_item_get_meta_raw(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_item_set_content:
        return _etebase_item_set_content(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_item_get_content:
        return _etebase_item_get_content(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_item_delete:
        return _etebase_item_delete(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_item_is_deleted:
        return _etebase_item_is_deleted(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_item_get_uid:
        return _etebase_item_get_uid(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_item_get_etag:
        return _etebase_item_get_etag(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_item_destroy:
        return _etebase_item_destroy(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_fs_cache_new:
        return _etebase_fs_cache_new(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_fs_cache_clear_user:
        return _etebase_fs_cache_clear_user(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_fs_cache_save_account:
        return _etebase_fs_cache_save_account(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_fs_cache_load_account:
        return _etebase_fs_cache_load_account(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_fs_cache_save_stoken:
        return _etebase_fs_cache_save_stoken(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_fs_cache_load_stoken:
        return _etebase_fs_cache_load_stoken(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_fs_cache_collection_save_stoken:
        return _etebase_fs_cache_collection_save_stoken(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_fs_cache_collection_load_stoken:
        return _etebase_fs_cache_collection_load_stoken(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_fs_cache_collection_set:
        return _etebase_fs_cache_collection_set(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_fs_cache_collection_unset:
        return _etebase_fs_cache_collection_unset(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_fs_cache_collection_get:
        return _etebase_fs_cache_collection_get(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_fs_cache_item_set:
        return _etebase_fs_cache_item_set(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_fs_cache_item_unset:
        return _etebase_fs_cache_item_unset(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_fs_cache_item_get:
        return _etebase_fs_cache_item_get(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_fs_cache_destroy:
        return _etebase_fs_cache_destroy(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_fetch_options_new:
        return _etebase_fetch_options_new(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_fetch_options_set_limit:
        return _etebase_fetch_options_set_limit(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_fetch_options_set_prefetch:
        return _etebase_fetch_options_set_prefetch(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_fetch_options_set_with_collection:
        return _etebase_fetch_options_set_with_collection(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_fetch_options_set_iterator:
        return _etebase_fetch_options_set_iterator(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_fetch_options_set_stoken:
        return _etebase_fetch_options_set_stoken(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_fetch_options_destroy:
        return _etebase_fetch_options_destroy(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_collection_member_manager_list:
        return _etebase_collection_member_manager_list(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_collection_member_manager_remove:
        return _etebase_collection_member_manager_remove(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_collection_member_manager_leave:
        return _etebase_collection_member_manager_leave(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_collection_member_manager_modify_access_level:
        return _etebase_collection_member_manager_modify_access_level(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_collection_member_manager_destroy:
        return _etebase_collection_member_manager_destroy(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_collection_member_clone:
        return _etebase_collection_member_clone(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_collection_member_get_username:
        return _etebase_collection_member_get_username(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_collection_member_get_access_level:
        return _etebase_collection_member_get_access_level(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_collection_member_destroy:
        return _etebase_collection_member_destroy(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_collection_manager_fetch:
        return _etebase_collection_manager_fetch(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_collection_manager_create:
        return _etebase_collection_manager_create(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_collection_manager_create_raw:
        return _etebase_collection_manager_create_raw(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_collection_manager_get_item_manager:
        return _etebase_collection_manager_get_item_manager(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_collection_manager_list:
        return _etebase_collection_manager_list(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_collection_manager_list_multi:
        return _etebase_collection_manager_list_multi(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_collection_manager_upload:
        return _etebase_collection_manager_upload(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_collection_manager_transaction:
        return _etebase_collection_manager_transaction(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_collection_manager_cache_load:
        return _etebase_collection_manager_cache_load(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_collection_manager_cache_save:
        return _etebase_collection_manager_cache_save(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_collection_manager_cache_save_with_content:
        return _etebase_collection_manager_cache_save_with_content(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_collection_manager_get_member_manager:
        return _etebase_collection_manager_get_member_manager(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_collection_manager_destroy:
        return _etebase_collection_manager_destroy(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_collection_list_response_get_stoken:
        return _etebase_collection_list_response_get_stoken(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_collection_list_response_get_data:
        return _etebase_collection_list_response_get_data(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_collection_list_response_is_done:
        return _etebase_collection_list_response_is_done(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_collection_list_response_get_removed_memberships:
        return _etebase_collection_list_response_get_removed_memberships(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_collection_list_response_destroy:
        return _etebase_collection_list_response_destroy(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_invitation_manager_list_incoming:
        return _etebase_invitation_manager_list_incoming(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_invitation_manager_list_outgoing:
        return _etebase_invitation_manager_list_outgoing(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_invitation_manager_accept:
        return _etebase_invitation_manager_accept(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_invitation_manager_reject:
        return _etebase_invitation_manager_reject(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_invitation_manager_fetch_user_profile:
        return _etebase_invitation_manager_fetch_user_profile(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_invitation_manager_invite:
        return _etebase_invitation_manager_invite(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_invitation_manager_disinvite:
        return _etebase_invitation_manager_disinvite(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_invitation_manager_get_pubkey:
        return _etebase_invitation_manager_get_pubkey(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_invitation_manager_destroy:
        return _etebase_invitation_manager_destroy(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_collection_clone:
        return _etebase_collection_clone(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_collection_verify:
        return _etebase_collection_verify(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_collection_set_meta:
        return _etebase_collection_set_meta(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_collection_get_meta:
        return _etebase_collection_get_meta(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_collection_set_meta_raw:
        return _etebase_collection_set_meta_raw(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_collection_get_meta_raw:
        return _etebase_collection_get_meta_raw(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_collection_set_content:
        return _etebase_collection_set_content(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_collection_get_content:
        return _etebase_collection_get_content(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_collection_delete:
        return _etebase_collection_delete(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_collection_is_deleted:
        return _etebase_collection_is_deleted(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_collection_get_uid:
        return _etebase_collection_get_uid(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_collection_get_etag:
        return _etebase_collection_get_etag(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_collection_get_stoken:
        return _etebase_collection_get_stoken(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_collection_as_item:
        return _etebase_collection_as_item(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_collection_get_collection_type:
        return _etebase_collection_get_collection_type(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_collection_get_access_level:
        return _etebase_collection_get_access_level(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_collection_destroy:
        return _etebase_collection_destroy(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_client_new:
        return _etebase_client_new(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_client_set_server_url:
        return _etebase_client_set_server_url(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_client_check_etebase_server:
        return _etebase_client_check_etebase_server(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_client_destroy:
        return _etebase_client_destroy(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_account_login:
        return _etebase_account_login(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_account_signup:
        return _etebase_account_signup(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_account_fetch_token:
        return _etebase_account_fetch_token(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_account_fetch_dashboard_url:
        return _etebase_account_fetch_dashboard_url(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_account_force_server_url:
        return _etebase_account_force_server_url(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_account_change_password:
        return _etebase_account_change_password(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_account_logout:
        return _etebase_account_logout(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_account_get_collection_manager:
        return _etebase_account_get_collection_manager(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_account_get_invitation_manager:
        return _etebase_account_get_invitation_manager(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_account_save:
        return _etebase_account_save(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_account_restore:
        return _etebase_account_restore(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_account_destroy:
        return _etebase_account_destroy(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #ETEBASE_UTILS_PRETTY_FINGERPRINT_SIZE:
        return _ETEBASE_UTILS_PRETTY_FINGERPRINT_SIZE(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_utils_randombytes:
        return _etebase_utils_randombytes(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_utils_pretty_fingerprint:
        return _etebase_utils_pretty_fingerprint(
          libEtebase,
          config,
          invocation,
          arena,
        );
      case #etebase_get_default_server_url:
        return _etebase_get_default_server_url(
          libEtebase,
          config,
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
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseUserProfile>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_user_profile_get_pubkey(this_);
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<_i8.TransferableTypedData>(
    invocation.id,
    _i8.TransferableTypedData.fromList([
      result
          .cast<_i6.Uint8>()
          .asTypedList(libEtebase.etebase_user_profile_get_pubkey_size(this_))
    ]),
  );
}

_i1.MethodResult _etebase_user_profile_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseUserProfile>.fromAddress(
      (invocation.arguments[0] as int));
  libEtebase.etebase_user_profile_destroy(this_);
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_user_new(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is String,
      'Parameter username must be of type String');
  assert(invocation.arguments[1] is String,
      'Parameter email must be of type String');
  final username = (invocation.arguments[0] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i6.Char>();
  final email = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i6.Char>();
  final result = libEtebase.etebase_user_new(
    username,
    email,
  );
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<int>(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_user_set_username(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is String,
      'Parameter username must be of type String');
  final this_ = _i6.Pointer<_i2.EtebaseUser>.fromAddress(
      (invocation.arguments[0] as int));
  final username = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i6.Char>();
  libEtebase.etebase_user_set_username(
    this_,
    username,
  );
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_user_get_username(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseUser>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_user_get_username(this_);
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<String>(
    invocation.id,
    result.cast<_i5.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_user_set_email(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is String,
      'Parameter email must be of type String');
  final this_ = _i6.Pointer<_i2.EtebaseUser>.fromAddress(
      (invocation.arguments[0] as int));
  final email = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i6.Char>();
  libEtebase.etebase_user_set_email(
    this_,
    email,
  );
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_user_get_email(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseUser>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_user_get_email(this_);
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<String>(
    invocation.id,
    result.cast<_i5.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_user_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseUser>.fromAddress(
      (invocation.arguments[0] as int));
  libEtebase.etebase_user_destroy(this_);
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_signed_invitation_clone(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseSignedInvitation>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_signed_invitation_clone(this_);
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<int>(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_signed_invitation_get_uid(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseSignedInvitation>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_signed_invitation_get_uid(this_);
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<String>(
    invocation.id,
    result.cast<_i5.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_signed_invitation_get_username(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseSignedInvitation>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_signed_invitation_get_username(this_);
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<String>(
    invocation.id,
    result.cast<_i5.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_signed_invitation_get_collection(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseSignedInvitation>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_signed_invitation_get_collection(this_);
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<String>(
    invocation.id,
    result.cast<_i5.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_signed_invitation_get_access_level(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseSignedInvitation>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_signed_invitation_get_access_level(this_);
  if (result < 0) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<_i9.EtebaseCollectionAccessLevel>(
    invocation.id,
    _i9.EtebaseCollectionAccessLevel.values[result],
  );
}

_i1.MethodResult _etebase_signed_invitation_get_from_username(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseSignedInvitation>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_signed_invitation_get_from_username(this_);
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<String>(
    invocation.id,
    result.cast<_i5.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_signed_invitation_get_from_pubkey(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseSignedInvitation>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_signed_invitation_get_from_pubkey(this_);
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<_i8.TransferableTypedData>(
    invocation.id,
    _i8.TransferableTypedData.fromList([
      result.cast<_i6.Uint8>().asTypedList(
          libEtebase.etebase_signed_invitation_get_from_pubkey_size(this_))
    ]),
  );
}

_i1.MethodResult _etebase_signed_invitation_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseSignedInvitation>.fromAddress(
      (invocation.arguments[0] as int));
  libEtebase.etebase_signed_invitation_destroy(this_);
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_removed_collection_get_uid(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseRemovedCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_removed_collection_get_uid(this_);
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<String>(
    invocation.id,
    result.cast<_i5.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_removed_collection_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseRemovedCollection>.fromAddress(
      (invocation.arguments[0] as int));
  libEtebase.etebase_removed_collection_destroy(this_);
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_invitation_list_response_get_iterator(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseInvitationListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  final result =
      libEtebase.etebase_invitation_list_response_get_iterator(this_);
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<String>(
    invocation.id,
    result.cast<_i5.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_invitation_list_response_get_data(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseInvitationListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  final dataSize =
      libEtebase.etebase_invitation_list_response_get_data_length(this_);
  final data = arena<_i6.Pointer<_i2.EtebaseSignedInvitation>>(dataSize);
  final result = libEtebase.etebase_invitation_list_response_get_data(
    this_,
    data,
  );
  if (result < 0) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<List<int>>(
    invocation.id,
    _i7.FfiHelpers.extractPointerList(
      data,
      dataSize,
      (p) => p.address,
    ),
  );
}

_i1.MethodResult _etebase_invitation_list_response_is_done(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseInvitationListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_invitation_list_response_is_done(this_);
  return _i1.MethodResult.successTyped<bool>(
    invocation.id,
    result,
  );
}

_i1.MethodResult _etebase_invitation_list_response_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseInvitationListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  libEtebase.etebase_invitation_list_response_destroy(this_);
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_item_revisions_list_response_get_iterator(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseItemRevisionsListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  final result =
      libEtebase.etebase_item_revisions_list_response_get_iterator(this_);
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<String>(
    invocation.id,
    result.cast<_i5.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_item_revisions_list_response_get_data(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseItemRevisionsListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  final dataSize =
      libEtebase.etebase_item_revisions_list_response_get_data_length(this_);
  final data = arena<_i6.Pointer<_i2.EtebaseItem>>(dataSize);
  final result = libEtebase.etebase_item_revisions_list_response_get_data(
    this_,
    data,
  );
  if (result < 0) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<List<int>>(
    invocation.id,
    _i7.FfiHelpers.extractPointerList(
      data,
      dataSize,
      (p) => p.address,
    ),
  );
}

_i1.MethodResult _etebase_item_revisions_list_response_is_done(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseItemRevisionsListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_item_revisions_list_response_is_done(this_);
  return _i1.MethodResult.successTyped<bool>(
    invocation.id,
    result,
  );
}

_i1.MethodResult _etebase_item_revisions_list_response_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseItemRevisionsListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  libEtebase.etebase_item_revisions_list_response_destroy(this_);
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_member_list_response_get_iterator(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseMemberListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_member_list_response_get_iterator(this_);
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<String>(
    invocation.id,
    result.cast<_i5.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_member_list_response_get_data(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseMemberListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  final dataSize =
      libEtebase.etebase_member_list_response_get_data_length(this_);
  final data = arena<_i6.Pointer<_i2.EtebaseCollectionMember>>(dataSize);
  final result = libEtebase.etebase_member_list_response_get_data(
    this_,
    data,
  );
  if (result < 0) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<List<int>>(
    invocation.id,
    _i7.FfiHelpers.extractPointerList(
      data,
      dataSize,
      (p) => p.address,
    ),
  );
}

_i1.MethodResult _etebase_member_list_response_is_done(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseMemberListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_member_list_response_is_done(this_);
  return _i1.MethodResult.successTyped<bool>(
    invocation.id,
    result,
  );
}

_i1.MethodResult _etebase_member_list_response_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseMemberListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  libEtebase.etebase_member_list_response_destroy(this_);
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_item_metadata_new(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 0,
      'Invocation must have exactly 0 arguments');
  final result = libEtebase.etebase_item_metadata_new();
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<int>(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_item_metadata_set_item_type(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is String,
      'Parameter itemType must be of type String');
  final this_ = _i6.Pointer<_i2.EtebaseItemMetadata>.fromAddress(
      (invocation.arguments[0] as int));
  final itemType = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i6.Char>();
  libEtebase.etebase_item_metadata_set_item_type(
    this_,
    itemType,
  );
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_item_metadata_get_item_type(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseItemMetadata>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_item_metadata_get_item_type(this_);
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<String>(
    invocation.id,
    result.cast<_i5.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_item_metadata_set_name(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is String,
      'Parameter name must be of type String');
  final this_ = _i6.Pointer<_i2.EtebaseItemMetadata>.fromAddress(
      (invocation.arguments[0] as int));
  final name = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i6.Char>();
  libEtebase.etebase_item_metadata_set_name(
    this_,
    name,
  );
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_item_metadata_get_name(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseItemMetadata>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_item_metadata_get_name(this_);
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<String>(
    invocation.id,
    result.cast<_i5.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_item_metadata_set_mtime(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is DateTime,
      'Parameter mtime must be of type DateTime');
  final this_ = _i6.Pointer<_i2.EtebaseItemMetadata>.fromAddress(
      (invocation.arguments[0] as int));
  final mtime = arena<_i6.Int64>()
    ..value = (invocation.arguments[1] as DateTime).millisecondsSinceEpoch;
  libEtebase.etebase_item_metadata_set_mtime(
    this_,
    mtime,
  );
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_item_metadata_get_mtime(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseItemMetadata>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_item_metadata_get_mtime(this_);
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<DateTime>(
    invocation.id,
    DateTime.fromMillisecondsSinceEpoch(result.value),
  );
}

_i1.MethodResult _etebase_item_metadata_set_description(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is String,
      'Parameter description must be of type String');
  final this_ = _i6.Pointer<_i2.EtebaseItemMetadata>.fromAddress(
      (invocation.arguments[0] as int));
  final description = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i6.Char>();
  libEtebase.etebase_item_metadata_set_description(
    this_,
    description,
  );
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_item_metadata_get_description(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseItemMetadata>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_item_metadata_get_description(this_);
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<String>(
    invocation.id,
    result.cast<_i5.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_item_metadata_set_color(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is String,
      'Parameter color must be of type String');
  final this_ = _i6.Pointer<_i2.EtebaseItemMetadata>.fromAddress(
      (invocation.arguments[0] as int));
  final color = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i6.Char>();
  libEtebase.etebase_item_metadata_set_color(
    this_,
    color,
  );
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_item_metadata_get_color(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseItemMetadata>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_item_metadata_get_color(this_);
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<String>(
    invocation.id,
    result.cast<_i5.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_item_metadata_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseItemMetadata>.fromAddress(
      (invocation.arguments[0] as int));
  libEtebase.etebase_item_metadata_destroy(this_);
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_item_manager_fetch(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is String,
      'Parameter itemUid must be of type String');
  assert(invocation.arguments[2] is int?,
      'Parameter fetchOptions must be of type int?');
  final this_ = _i6.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final itemUid = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i6.Char>();
  final fetchOptions_address = (invocation.arguments[2] as int?);
  final fetchOptions = fetchOptions_address == null
      ? _i6.nullptr
      : _i6.Pointer<_i2.EtebaseFetchOptions>.fromAddress(fetchOptions_address);
  final result = libEtebase.etebase_item_manager_fetch(
    this_,
    itemUid,
    fetchOptions,
  );
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<int>(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_item_manager_create(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is int, 'Parameter meta must be of type int');
  assert(invocation.arguments[2] is _i8.TransferableTypedData,
      'Parameter content must be of type TransferableTypedData');
  final this_ = _i6.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final meta = _i6.Pointer<_i2.EtebaseItemMetadata>.fromAddress(
      (invocation.arguments[1] as int));
  final content_buffer = (invocation.arguments[2] as _i8.TransferableTypedData)
      .materialize()
      .asUint8List();
  final contentSize = content_buffer.length;
  final content = arena<_i6.Uint8>(contentSize);
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
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<int>(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_item_manager_create_raw(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is _i8.TransferableTypedData,
      'Parameter meta must be of type TransferableTypedData');
  assert(invocation.arguments[2] is _i8.TransferableTypedData,
      'Parameter content must be of type TransferableTypedData');
  final this_ = _i6.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final meta_buffer = (invocation.arguments[1] as _i8.TransferableTypedData)
      .materialize()
      .asUint8List();
  final metaSize = meta_buffer.length;
  final meta = arena<_i6.Uint8>(metaSize);
  meta.asTypedList(metaSize).setAll(
        0,
        meta_buffer,
      );
  final content_buffer = (invocation.arguments[2] as _i8.TransferableTypedData)
      .materialize()
      .asUint8List();
  final contentSize = content_buffer.length;
  final content = arena<_i6.Uint8>(contentSize);
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
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<int>(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_item_manager_list(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is int?,
      'Parameter fetchOptions must be of type int?');
  final this_ = _i6.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final fetchOptions_address = (invocation.arguments[1] as int?);
  final fetchOptions = fetchOptions_address == null
      ? _i6.nullptr
      : _i6.Pointer<_i2.EtebaseFetchOptions>.fromAddress(fetchOptions_address);
  final result = libEtebase.etebase_item_manager_list(
    this_,
    fetchOptions,
  );
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<int>(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_item_manager_item_revisions(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is int, 'Parameter item must be of type int');
  assert(invocation.arguments[2] is int?,
      'Parameter fetchOptions must be of type int?');
  final this_ = _i6.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final item = _i6.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[1] as int));
  final fetchOptions_address = (invocation.arguments[2] as int?);
  final fetchOptions = fetchOptions_address == null
      ? _i6.nullptr
      : _i6.Pointer<_i2.EtebaseFetchOptions>.fromAddress(fetchOptions_address);
  final result = libEtebase.etebase_item_manager_item_revisions(
    this_,
    item,
    fetchOptions,
  );
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<int>(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_item_manager_fetch_updates(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is List<int>,
      'Parameter items must be of type List<int>');
  assert(invocation.arguments[2] is int?,
      'Parameter fetchOptions must be of type int?');
  final this_ = _i6.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final itemsSize = (invocation.arguments[1] as List<int>).length;
  final items = arena<_i6.Pointer<_i2.EtebaseItem>>(itemsSize);
  _i7.FfiHelpers.assignPointerList(
    items,
    (invocation.arguments[1] as List<int>),
    _i6.Pointer<_i2.EtebaseItem>.fromAddress,
  );
  final fetchOptions_address = (invocation.arguments[2] as int?);
  final fetchOptions = fetchOptions_address == null
      ? _i6.nullptr
      : _i6.Pointer<_i2.EtebaseFetchOptions>.fromAddress(fetchOptions_address);
  final result = libEtebase.etebase_item_manager_fetch_updates(
    this_,
    items,
    itemsSize,
    fetchOptions,
  );
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<int>(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_item_manager_fetch_multi(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is List<String>,
      'Parameter items must be of type List<String>');
  assert(invocation.arguments[2] is int?,
      'Parameter fetchOptions must be of type int?');
  final this_ = _i6.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final itemsSize = (invocation.arguments[1] as List<String>).length;
  final items = arena<_i6.Pointer<_i6.Char>>(itemsSize);
  _i7.FfiHelpers.assignPointerList(
    items,
    (invocation.arguments[1] as List<String>),
    (s) => s.toNativeUtf8(allocator: arena).cast<_i6.Char>(),
  );
  final fetchOptions_address = (invocation.arguments[2] as int?);
  final fetchOptions = fetchOptions_address == null
      ? _i6.nullptr
      : _i6.Pointer<_i2.EtebaseFetchOptions>.fromAddress(fetchOptions_address);
  final result = libEtebase.etebase_item_manager_fetch_multi(
    this_,
    items,
    itemsSize,
    fetchOptions,
  );
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<int>(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_item_manager_batch(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is List<int>,
      'Parameter items must be of type List<int>');
  assert(invocation.arguments[2] is int?,
      'Parameter fetchOptions must be of type int?');
  final this_ = _i6.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final itemsSize = (invocation.arguments[1] as List<int>).length;
  final items = arena<_i6.Pointer<_i2.EtebaseItem>>(itemsSize);
  _i7.FfiHelpers.assignPointerList(
    items,
    (invocation.arguments[1] as List<int>),
    _i6.Pointer<_i2.EtebaseItem>.fromAddress,
  );
  final fetchOptions_address = (invocation.arguments[2] as int?);
  final fetchOptions = fetchOptions_address == null
      ? _i6.nullptr
      : _i6.Pointer<_i2.EtebaseFetchOptions>.fromAddress(fetchOptions_address);
  final result = libEtebase.etebase_item_manager_batch(
    this_,
    items,
    itemsSize,
    fetchOptions,
  );
  if (result < 0) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_item_manager_batch_deps(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 4,
      'Invocation must have exactly 4 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is List<int>,
      'Parameter items must be of type List<int>');
  assert(invocation.arguments[2] is List<int>,
      'Parameter deps must be of type List<int>');
  assert(invocation.arguments[3] is int?,
      'Parameter fetchOptions must be of type int?');
  final this_ = _i6.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final itemsSize = (invocation.arguments[1] as List<int>).length;
  final items = arena<_i6.Pointer<_i2.EtebaseItem>>(itemsSize);
  _i7.FfiHelpers.assignPointerList(
    items,
    (invocation.arguments[1] as List<int>),
    _i6.Pointer<_i2.EtebaseItem>.fromAddress,
  );
  final depsSize = (invocation.arguments[2] as List<int>).length;
  final deps = arena<_i6.Pointer<_i2.EtebaseItem>>(depsSize);
  _i7.FfiHelpers.assignPointerList(
    deps,
    (invocation.arguments[2] as List<int>),
    _i6.Pointer<_i2.EtebaseItem>.fromAddress,
  );
  final fetchOptions_address = (invocation.arguments[3] as int?);
  final fetchOptions = fetchOptions_address == null
      ? _i6.nullptr
      : _i6.Pointer<_i2.EtebaseFetchOptions>.fromAddress(fetchOptions_address);
  final result = libEtebase.etebase_item_manager_batch_deps(
    this_,
    items,
    itemsSize,
    deps,
    depsSize,
    fetchOptions,
  );
  if (result < 0) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_item_manager_transaction(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is List<int>,
      'Parameter items must be of type List<int>');
  assert(invocation.arguments[2] is int?,
      'Parameter fetchOptions must be of type int?');
  final this_ = _i6.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final itemsSize = (invocation.arguments[1] as List<int>).length;
  final items = arena<_i6.Pointer<_i2.EtebaseItem>>(itemsSize);
  _i7.FfiHelpers.assignPointerList(
    items,
    (invocation.arguments[1] as List<int>),
    _i6.Pointer<_i2.EtebaseItem>.fromAddress,
  );
  final fetchOptions_address = (invocation.arguments[2] as int?);
  final fetchOptions = fetchOptions_address == null
      ? _i6.nullptr
      : _i6.Pointer<_i2.EtebaseFetchOptions>.fromAddress(fetchOptions_address);
  final result = libEtebase.etebase_item_manager_transaction(
    this_,
    items,
    itemsSize,
    fetchOptions,
  );
  if (result < 0) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_item_manager_transaction_deps(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 4,
      'Invocation must have exactly 4 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is List<int>,
      'Parameter items must be of type List<int>');
  assert(invocation.arguments[2] is List<int>,
      'Parameter deps must be of type List<int>');
  assert(invocation.arguments[3] is int?,
      'Parameter fetchOptions must be of type int?');
  final this_ = _i6.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final itemsSize = (invocation.arguments[1] as List<int>).length;
  final items = arena<_i6.Pointer<_i2.EtebaseItem>>(itemsSize);
  _i7.FfiHelpers.assignPointerList(
    items,
    (invocation.arguments[1] as List<int>),
    _i6.Pointer<_i2.EtebaseItem>.fromAddress,
  );
  final depsSize = (invocation.arguments[2] as List<int>).length;
  final deps = arena<_i6.Pointer<_i2.EtebaseItem>>(depsSize);
  _i7.FfiHelpers.assignPointerList(
    deps,
    (invocation.arguments[2] as List<int>),
    _i6.Pointer<_i2.EtebaseItem>.fromAddress,
  );
  final fetchOptions_address = (invocation.arguments[3] as int?);
  final fetchOptions = fetchOptions_address == null
      ? _i6.nullptr
      : _i6.Pointer<_i2.EtebaseFetchOptions>.fromAddress(fetchOptions_address);
  final result = libEtebase.etebase_item_manager_transaction_deps(
    this_,
    items,
    itemsSize,
    deps,
    depsSize,
    fetchOptions,
  );
  if (result < 0) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_item_manager_cache_load(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is _i8.TransferableTypedData,
      'Parameter cached must be of type TransferableTypedData');
  final this_ = _i6.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final cached_buffer = (invocation.arguments[1] as _i8.TransferableTypedData)
      .materialize()
      .asUint8List();
  final cachedSize = cached_buffer.length;
  final cached = arena<_i6.Uint8>(cachedSize);
  cached.asTypedList(cachedSize).setAll(
        0,
        cached_buffer,
      );
  final result = libEtebase.etebase_item_manager_cache_load(
    this_,
    cached.cast(),
    cachedSize,
  );
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<int>(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_item_manager_cache_save(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is int, 'Parameter item must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final item = _i6.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[1] as int));
  final retSize = arena<_i6.UnsignedLong>()..value = 0;
  final result = libEtebase.etebase_item_manager_cache_save(
    this_,
    item,
    retSize,
  );
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<_i8.TransferableTypedData>(
    invocation.id,
    _i8.TransferableTypedData.fromList(
        [result.cast<_i6.Uint8>().asTypedList(retSize.value)]),
  );
}

_i1.MethodResult _etebase_item_manager_cache_save_with_content(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is int, 'Parameter item must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final item = _i6.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[1] as int));
  final retSize = arena<_i6.UnsignedLong>()..value = 0;
  final result = libEtebase.etebase_item_manager_cache_save_with_content(
    this_,
    item,
    retSize,
  );
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<_i8.TransferableTypedData>(
    invocation.id,
    _i8.TransferableTypedData.fromList(
        [result.cast<_i6.Uint8>().asTypedList(retSize.value)]),
  );
}

_i1.MethodResult _etebase_item_manager_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  libEtebase.etebase_item_manager_destroy(this_);
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_item_list_response_get_stoken(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseItemListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_item_list_response_get_stoken(this_);
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<String>(
    invocation.id,
    result.cast<_i5.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_item_list_response_get_data(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseItemListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  final dataSize = libEtebase.etebase_item_list_response_get_data_length(this_);
  final data = arena<_i6.Pointer<_i2.EtebaseItem>>(dataSize);
  final result = libEtebase.etebase_item_list_response_get_data(
    this_,
    data,
  );
  if (result < 0) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<List<int>>(
    invocation.id,
    _i7.FfiHelpers.extractPointerList(
      data,
      dataSize,
      (p) => p.address,
    ),
  );
}

_i1.MethodResult _etebase_item_list_response_is_done(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseItemListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_item_list_response_is_done(this_);
  return _i1.MethodResult.successTyped<bool>(
    invocation.id,
    result,
  );
}

_i1.MethodResult _etebase_item_list_response_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseItemListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  libEtebase.etebase_item_list_response_destroy(this_);
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_item_clone(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_item_clone(this_);
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<int>(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_item_verify(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_item_verify(this_);
  return _i1.MethodResult.successTyped<bool>(
    invocation.id,
    result,
  );
}

_i1.MethodResult _etebase_item_set_meta(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is int, 'Parameter meta must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  final meta = _i6.Pointer<_i2.EtebaseItemMetadata>.fromAddress(
      (invocation.arguments[1] as int));
  final result = libEtebase.etebase_item_set_meta(
    this_,
    meta,
  );
  if (result < 0) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_item_get_meta(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_item_get_meta(this_);
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<int>(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_item_set_meta_raw(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is _i8.TransferableTypedData,
      'Parameter meta must be of type TransferableTypedData');
  final this_ = _i6.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  final meta_buffer = (invocation.arguments[1] as _i8.TransferableTypedData)
      .materialize()
      .asUint8List();
  final metaSize = meta_buffer.length;
  final meta = arena<_i6.Uint8>(metaSize);
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
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_item_get_meta_raw(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena, {
  int? reinvokedWithSize,
}) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is int?,
      'Parameter sizeHint must be of type int?');
  final this_ = _i6.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  final bufSize = reinvokedWithSize ??
      (invocation.arguments[1] as int?) ??
      config.defaultContentBufferSize;
  final buf = arena<_i6.Uint8>(bufSize);
  final result = libEtebase.etebase_item_get_meta_raw(
    this_,
    buf.cast(),
    bufSize,
  );
  if (result < 0) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  } else if (result <= bufSize) {
    return _i1.MethodResult.successTyped<_i8.TransferableTypedData>(
      invocation.id,
      _i8.TransferableTypedData.fromList(
          [buf.cast<_i6.Uint8>().asTypedList(result)]),
    );
  } else if (reinvokedWithSize != null) {
    return _i1.MethodResult.failure(
      invocation.id,
      _i10.EtebaseErrorCode.generic,
      'output size of etebase_item_get_meta_raw changed during invocation',
    );
  } else {
    return _etebase_item_get_meta_raw(
      libEtebase,
      config,
      invocation,
      arena,
      reinvokedWithSize: result,
    );
  }
}

_i1.MethodResult _etebase_item_set_content(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is _i8.TransferableTypedData,
      'Parameter content must be of type TransferableTypedData');
  final this_ = _i6.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  final content_buffer = (invocation.arguments[1] as _i8.TransferableTypedData)
      .materialize()
      .asUint8List();
  final contentSize = content_buffer.length;
  final content = arena<_i6.Uint8>(contentSize);
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
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_item_get_content(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena, {
  int? reinvokedWithSize,
}) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is int?,
      'Parameter sizeHint must be of type int?');
  final this_ = _i6.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  final bufSize = reinvokedWithSize ??
      (invocation.arguments[1] as int?) ??
      config.defaultContentBufferSize;
  final buf = arena<_i6.Uint8>(bufSize);
  final result = libEtebase.etebase_item_get_content(
    this_,
    buf.cast(),
    bufSize,
  );
  if (result < 0) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  } else if (result <= bufSize) {
    return _i1.MethodResult.successTyped<_i8.TransferableTypedData>(
      invocation.id,
      _i8.TransferableTypedData.fromList(
          [buf.cast<_i6.Uint8>().asTypedList(result)]),
    );
  } else if (reinvokedWithSize != null) {
    return _i1.MethodResult.failure(
      invocation.id,
      _i10.EtebaseErrorCode.generic,
      'output size of etebase_item_get_content changed during invocation',
    );
  } else {
    return _etebase_item_get_content(
      libEtebase,
      config,
      invocation,
      arena,
      reinvokedWithSize: result,
    );
  }
}

_i1.MethodResult _etebase_item_delete(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_item_delete(this_);
  if (result < 0) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_item_is_deleted(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_item_is_deleted(this_);
  return _i1.MethodResult.successTyped<bool>(
    invocation.id,
    result,
  );
}

_i1.MethodResult _etebase_item_get_uid(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_item_get_uid(this_);
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<String>(
    invocation.id,
    result.cast<_i5.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_item_get_etag(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_item_get_etag(this_);
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<String>(
    invocation.id,
    result.cast<_i5.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_item_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  libEtebase.etebase_item_destroy(this_);
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_fs_cache_new(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is String,
      'Parameter path must be of type String');
  assert(invocation.arguments[1] is String,
      'Parameter username must be of type String');
  final path = (invocation.arguments[0] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i6.Char>();
  final username = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i6.Char>();
  final result = libEtebase.etebase_fs_cache_new(
    path,
    username,
  );
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<int>(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_fs_cache_clear_user(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_fs_cache_clear_user(this_);
  if (result < 0) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_fs_cache_save_account(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(
      invocation.arguments[1] is int, 'Parameter etebase must be of type int');
  assert(invocation.arguments[2] is _i8.TransferableTypedData?,
      'Parameter encryptionKey must be of type TransferableTypedData?');
  final this_ = _i6.Pointer<_i2.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final etebase = _i6.Pointer<_i2.EtebaseAccount>.fromAddress(
      (invocation.arguments[1] as int));
  final encryptionKey_buffer =
      (invocation.arguments[2] as _i8.TransferableTypedData?)
          ?.materialize()
          .asUint8List();
  final encryptionKeySize = encryptionKey_buffer?.length ?? 0;
  final encryptionKey = encryptionKey_buffer == null
      ? _i6.nullptr
      : arena<_i6.Uint8>(encryptionKeySize);
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
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_fs_cache_load_account(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(
      invocation.arguments[1] is int, 'Parameter client must be of type int');
  assert(invocation.arguments[2] is _i8.TransferableTypedData?,
      'Parameter encryptionKey must be of type TransferableTypedData?');
  final this_ = _i6.Pointer<_i2.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final client = _i6.Pointer<_i2.EtebaseClient>.fromAddress(
      (invocation.arguments[1] as int));
  final encryptionKey_buffer =
      (invocation.arguments[2] as _i8.TransferableTypedData?)
          ?.materialize()
          .asUint8List();
  final encryptionKeySize = encryptionKey_buffer?.length ?? 0;
  final encryptionKey = encryptionKey_buffer == null
      ? _i6.nullptr
      : arena<_i6.Uint8>(encryptionKeySize);
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
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<int>(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_fs_cache_save_stoken(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is String,
      'Parameter stoken must be of type String');
  final this_ = _i6.Pointer<_i2.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final stoken = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i6.Char>();
  final result = libEtebase.etebase_fs_cache_save_stoken(
    this_,
    stoken,
  );
  if (result < 0) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_fs_cache_load_stoken(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_fs_cache_load_stoken(this_);
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<String>(
    invocation.id,
    result.cast<_i5.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_fs_cache_collection_save_stoken(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is String,
      'Parameter colUid must be of type String');
  assert(invocation.arguments[2] is String,
      'Parameter stoken must be of type String');
  final this_ = _i6.Pointer<_i2.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final colUid = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i6.Char>();
  final stoken = (invocation.arguments[2] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i6.Char>();
  final result = libEtebase.etebase_fs_cache_collection_save_stoken(
    this_,
    colUid,
    stoken,
  );
  if (result < 0) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_fs_cache_collection_load_stoken(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is String,
      'Parameter colUid must be of type String');
  final this_ = _i6.Pointer<_i2.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final colUid = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i6.Char>();
  final result = libEtebase.etebase_fs_cache_collection_load_stoken(
    this_,
    colUid,
  );
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<String>(
    invocation.id,
    result.cast<_i5.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_fs_cache_collection_set(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(
      invocation.arguments[1] is int, 'Parameter colMgr must be of type int');
  assert(invocation.arguments[2] is int, 'Parameter col must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final colMgr = _i6.Pointer<_i2.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[1] as int));
  final col = _i6.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[2] as int));
  final result = libEtebase.etebase_fs_cache_collection_set(
    this_,
    colMgr,
    col,
  );
  if (result < 0) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_fs_cache_collection_unset(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(
      invocation.arguments[1] is int, 'Parameter colMgr must be of type int');
  assert(invocation.arguments[2] is String,
      'Parameter colUid must be of type String');
  final this_ = _i6.Pointer<_i2.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final colMgr = _i6.Pointer<_i2.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[1] as int));
  final colUid = (invocation.arguments[2] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i6.Char>();
  final result = libEtebase.etebase_fs_cache_collection_unset(
    this_,
    colMgr,
    colUid,
  );
  if (result < 0) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_fs_cache_collection_get(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(
      invocation.arguments[1] is int, 'Parameter colMgr must be of type int');
  assert(invocation.arguments[2] is String,
      'Parameter colUid must be of type String');
  final this_ = _i6.Pointer<_i2.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final colMgr = _i6.Pointer<_i2.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[1] as int));
  final colUid = (invocation.arguments[2] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i6.Char>();
  final result = libEtebase.etebase_fs_cache_collection_get(
    this_,
    colMgr,
    colUid,
  );
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<int>(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_fs_cache_item_set(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 4,
      'Invocation must have exactly 4 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(
      invocation.arguments[1] is int, 'Parameter itemMgr must be of type int');
  assert(invocation.arguments[2] is String,
      'Parameter colUid must be of type String');
  assert(invocation.arguments[3] is int, 'Parameter item must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final itemMgr = _i6.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[1] as int));
  final colUid = (invocation.arguments[2] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i6.Char>();
  final item = _i6.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[3] as int));
  final result = libEtebase.etebase_fs_cache_item_set(
    this_,
    itemMgr,
    colUid,
    item,
  );
  if (result < 0) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_fs_cache_item_unset(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
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
  final this_ = _i6.Pointer<_i2.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final itemMgr = _i6.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[1] as int));
  final colUid = (invocation.arguments[2] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i6.Char>();
  final itemUid = (invocation.arguments[3] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i6.Char>();
  final result = libEtebase.etebase_fs_cache_item_unset(
    this_,
    itemMgr,
    colUid,
    itemUid,
  );
  if (result < 0) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_fs_cache_item_get(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
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
  final this_ = _i6.Pointer<_i2.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final itemMgr = _i6.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[1] as int));
  final colUid = (invocation.arguments[2] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i6.Char>();
  final itemUid = (invocation.arguments[3] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i6.Char>();
  final result = libEtebase.etebase_fs_cache_item_get(
    this_,
    itemMgr,
    colUid,
    itemUid,
  );
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<int>(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_fs_cache_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  libEtebase.etebase_fs_cache_destroy(this_);
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_fetch_options_new(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 0,
      'Invocation must have exactly 0 arguments');
  final result = libEtebase.etebase_fetch_options_new();
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<int>(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_fetch_options_set_limit(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is int, 'Parameter limit must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseFetchOptions>.fromAddress(
      (invocation.arguments[0] as int));
  final limit = (invocation.arguments[1] as int);
  libEtebase.etebase_fetch_options_set_limit(
    this_,
    limit,
  );
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_fetch_options_set_prefetch(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is _i11.EtebasePrefetchOption,
      'Parameter prefetch must be of type EtebasePrefetchOption');
  final this_ = _i6.Pointer<_i2.EtebaseFetchOptions>.fromAddress(
      (invocation.arguments[0] as int));
  final prefetch =
      (invocation.arguments[1] as _i11.EtebasePrefetchOption).index;
  libEtebase.etebase_fetch_options_set_prefetch(
    this_,
    prefetch,
  );
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_fetch_options_set_with_collection(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is bool,
      'Parameter withCollection must be of type bool');
  final this_ = _i6.Pointer<_i2.EtebaseFetchOptions>.fromAddress(
      (invocation.arguments[0] as int));
  final withCollection = (invocation.arguments[1] as bool);
  libEtebase.etebase_fetch_options_set_with_collection(
    this_,
    withCollection,
  );
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_fetch_options_set_iterator(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is String,
      'Parameter iterator must be of type String');
  final this_ = _i6.Pointer<_i2.EtebaseFetchOptions>.fromAddress(
      (invocation.arguments[0] as int));
  final iterator = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i6.Char>();
  libEtebase.etebase_fetch_options_set_iterator(
    this_,
    iterator,
  );
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_fetch_options_set_stoken(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is String,
      'Parameter stoken must be of type String');
  final this_ = _i6.Pointer<_i2.EtebaseFetchOptions>.fromAddress(
      (invocation.arguments[0] as int));
  final stoken = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i6.Char>();
  libEtebase.etebase_fetch_options_set_stoken(
    this_,
    stoken,
  );
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_fetch_options_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseFetchOptions>.fromAddress(
      (invocation.arguments[0] as int));
  libEtebase.etebase_fetch_options_destroy(this_);
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_collection_member_manager_list(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is int?,
      'Parameter fetchOptions must be of type int?');
  final this_ = _i6.Pointer<_i2.EtebaseCollectionMemberManager>.fromAddress(
      (invocation.arguments[0] as int));
  final fetchOptions_address = (invocation.arguments[1] as int?);
  final fetchOptions = fetchOptions_address == null
      ? _i6.nullptr
      : _i6.Pointer<_i2.EtebaseFetchOptions>.fromAddress(fetchOptions_address);
  final result = libEtebase.etebase_collection_member_manager_list(
    this_,
    fetchOptions,
  );
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<int>(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_collection_member_manager_remove(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is String,
      'Parameter username must be of type String');
  final this_ = _i6.Pointer<_i2.EtebaseCollectionMemberManager>.fromAddress(
      (invocation.arguments[0] as int));
  final username = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i6.Char>();
  final result = libEtebase.etebase_collection_member_manager_remove(
    this_,
    username,
  );
  if (result < 0) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_collection_member_manager_leave(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseCollectionMemberManager>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_member_manager_leave(this_);
  if (result < 0) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_collection_member_manager_modify_access_level(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is String,
      'Parameter username must be of type String');
  assert(invocation.arguments[2] is _i9.EtebaseCollectionAccessLevel,
      'Parameter accessLevel must be of type EtebaseCollectionAccessLevel');
  final this_ = _i6.Pointer<_i2.EtebaseCollectionMemberManager>.fromAddress(
      (invocation.arguments[0] as int));
  final username = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i6.Char>();
  final accessLevel =
      (invocation.arguments[2] as _i9.EtebaseCollectionAccessLevel).index;
  final result =
      libEtebase.etebase_collection_member_manager_modify_access_level(
    this_,
    username,
    accessLevel,
  );
  if (result < 0) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_collection_member_manager_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseCollectionMemberManager>.fromAddress(
      (invocation.arguments[0] as int));
  libEtebase.etebase_collection_member_manager_destroy(this_);
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_collection_member_clone(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseCollectionMember>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_member_clone(this_);
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<int>(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_collection_member_get_username(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseCollectionMember>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_member_get_username(this_);
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<String>(
    invocation.id,
    result.cast<_i5.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_collection_member_get_access_level(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseCollectionMember>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_member_get_access_level(this_);
  if (result < 0) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<_i9.EtebaseCollectionAccessLevel>(
    invocation.id,
    _i9.EtebaseCollectionAccessLevel.values[result],
  );
}

_i1.MethodResult _etebase_collection_member_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseCollectionMember>.fromAddress(
      (invocation.arguments[0] as int));
  libEtebase.etebase_collection_member_destroy(this_);
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_collection_manager_fetch(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is String,
      'Parameter colUid must be of type String');
  assert(invocation.arguments[2] is int?,
      'Parameter fetchOptions must be of type int?');
  final this_ = _i6.Pointer<_i2.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  final colUid = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i6.Char>();
  final fetchOptions_address = (invocation.arguments[2] as int?);
  final fetchOptions = fetchOptions_address == null
      ? _i6.nullptr
      : _i6.Pointer<_i2.EtebaseFetchOptions>.fromAddress(fetchOptions_address);
  final result = libEtebase.etebase_collection_manager_fetch(
    this_,
    colUid,
    fetchOptions,
  );
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<int>(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_collection_manager_create(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 4,
      'Invocation must have exactly 4 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is String,
      'Parameter collectionType must be of type String');
  assert(invocation.arguments[2] is int, 'Parameter meta must be of type int');
  assert(invocation.arguments[3] is _i8.TransferableTypedData,
      'Parameter content must be of type TransferableTypedData');
  final this_ = _i6.Pointer<_i2.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  final collectionType = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i6.Char>();
  final meta = _i6.Pointer<_i2.EtebaseItemMetadata>.fromAddress(
      (invocation.arguments[2] as int));
  final content_buffer = (invocation.arguments[3] as _i8.TransferableTypedData)
      .materialize()
      .asUint8List();
  final contentSize = content_buffer.length;
  final content = arena<_i6.Uint8>(contentSize);
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
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<int>(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_collection_manager_create_raw(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 4,
      'Invocation must have exactly 4 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is String,
      'Parameter collectionType must be of type String');
  assert(invocation.arguments[2] is _i8.TransferableTypedData,
      'Parameter meta must be of type TransferableTypedData');
  assert(invocation.arguments[3] is _i8.TransferableTypedData,
      'Parameter content must be of type TransferableTypedData');
  final this_ = _i6.Pointer<_i2.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  final collectionType = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i6.Char>();
  final meta_buffer = (invocation.arguments[2] as _i8.TransferableTypedData)
      .materialize()
      .asUint8List();
  final metaSize = meta_buffer.length;
  final meta = arena<_i6.Uint8>(metaSize);
  meta.asTypedList(metaSize).setAll(
        0,
        meta_buffer,
      );
  final content_buffer = (invocation.arguments[3] as _i8.TransferableTypedData)
      .materialize()
      .asUint8List();
  final contentSize = content_buffer.length;
  final content = arena<_i6.Uint8>(contentSize);
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
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<int>(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_collection_manager_get_item_manager(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is int, 'Parameter col must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  final col = _i6.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[1] as int));
  final result = libEtebase.etebase_collection_manager_get_item_manager(
    this_,
    col,
  );
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<int>(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_collection_manager_list(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is String,
      'Parameter collectionType must be of type String');
  assert(invocation.arguments[2] is int?,
      'Parameter fetchOptions must be of type int?');
  final this_ = _i6.Pointer<_i2.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  final collectionType = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i6.Char>();
  final fetchOptions_address = (invocation.arguments[2] as int?);
  final fetchOptions = fetchOptions_address == null
      ? _i6.nullptr
      : _i6.Pointer<_i2.EtebaseFetchOptions>.fromAddress(fetchOptions_address);
  final result = libEtebase.etebase_collection_manager_list(
    this_,
    collectionType,
    fetchOptions,
  );
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<int>(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_collection_manager_list_multi(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is List<String>,
      'Parameter collectionTypes must be of type List<String>');
  assert(invocation.arguments[2] is int?,
      'Parameter fetchOptions must be of type int?');
  final this_ = _i6.Pointer<_i2.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  final collectionTypesSize = (invocation.arguments[1] as List<String>).length;
  final collectionTypes = arena<_i6.Pointer<_i6.Char>>(collectionTypesSize);
  _i7.FfiHelpers.assignPointerList(
    collectionTypes,
    (invocation.arguments[1] as List<String>),
    (s) => s.toNativeUtf8(allocator: arena).cast<_i6.Char>(),
  );
  final fetchOptions_address = (invocation.arguments[2] as int?);
  final fetchOptions = fetchOptions_address == null
      ? _i6.nullptr
      : _i6.Pointer<_i2.EtebaseFetchOptions>.fromAddress(fetchOptions_address);
  final result = libEtebase.etebase_collection_manager_list_multi(
    this_,
    collectionTypes,
    collectionTypesSize,
    fetchOptions,
  );
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<int>(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_collection_manager_upload(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is int,
      'Parameter collection must be of type int');
  assert(invocation.arguments[2] is int?,
      'Parameter fetchOptions must be of type int?');
  final this_ = _i6.Pointer<_i2.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  final collection = _i6.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[1] as int));
  final fetchOptions_address = (invocation.arguments[2] as int?);
  final fetchOptions = fetchOptions_address == null
      ? _i6.nullptr
      : _i6.Pointer<_i2.EtebaseFetchOptions>.fromAddress(fetchOptions_address);
  final result = libEtebase.etebase_collection_manager_upload(
    this_,
    collection,
    fetchOptions,
  );
  if (result < 0) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_collection_manager_transaction(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is int,
      'Parameter collection must be of type int');
  assert(invocation.arguments[2] is int?,
      'Parameter fetchOptions must be of type int?');
  final this_ = _i6.Pointer<_i2.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  final collection = _i6.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[1] as int));
  final fetchOptions_address = (invocation.arguments[2] as int?);
  final fetchOptions = fetchOptions_address == null
      ? _i6.nullptr
      : _i6.Pointer<_i2.EtebaseFetchOptions>.fromAddress(fetchOptions_address);
  final result = libEtebase.etebase_collection_manager_transaction(
    this_,
    collection,
    fetchOptions,
  );
  if (result < 0) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_collection_manager_cache_load(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is _i8.TransferableTypedData,
      'Parameter cached must be of type TransferableTypedData');
  final this_ = _i6.Pointer<_i2.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  final cached_buffer = (invocation.arguments[1] as _i8.TransferableTypedData)
      .materialize()
      .asUint8List();
  final cachedSize = cached_buffer.length;
  final cached = arena<_i6.Uint8>(cachedSize);
  cached.asTypedList(cachedSize).setAll(
        0,
        cached_buffer,
      );
  final result = libEtebase.etebase_collection_manager_cache_load(
    this_,
    cached.cast(),
    cachedSize,
  );
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<int>(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_collection_manager_cache_save(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is int,
      'Parameter collection must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  final collection = _i6.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[1] as int));
  final retSize = arena<_i6.UnsignedLong>()..value = 0;
  final result = libEtebase.etebase_collection_manager_cache_save(
    this_,
    collection,
    retSize,
  );
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<_i8.TransferableTypedData>(
    invocation.id,
    _i8.TransferableTypedData.fromList(
        [result.cast<_i6.Uint8>().asTypedList(retSize.value)]),
  );
}

_i1.MethodResult _etebase_collection_manager_cache_save_with_content(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is int,
      'Parameter collection must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  final collection = _i6.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[1] as int));
  final retSize = arena<_i6.UnsignedLong>()..value = 0;
  final result = libEtebase.etebase_collection_manager_cache_save_with_content(
    this_,
    collection,
    retSize,
  );
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<_i8.TransferableTypedData>(
    invocation.id,
    _i8.TransferableTypedData.fromList(
        [result.cast<_i6.Uint8>().asTypedList(retSize.value)]),
  );
}

_i1.MethodResult _etebase_collection_manager_get_member_manager(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is int, 'Parameter col must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  final col = _i6.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[1] as int));
  final result = libEtebase.etebase_collection_manager_get_member_manager(
    this_,
    col,
  );
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<int>(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_collection_manager_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  libEtebase.etebase_collection_manager_destroy(this_);
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_collection_list_response_get_stoken(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseCollectionListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_list_response_get_stoken(this_);
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<String>(
    invocation.id,
    result.cast<_i5.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_collection_list_response_get_data(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseCollectionListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  final dataSize =
      libEtebase.etebase_collection_list_response_get_data_length(this_);
  final data = arena<_i6.Pointer<_i2.EtebaseCollection>>(dataSize);
  final result = libEtebase.etebase_collection_list_response_get_data(
    this_,
    data,
  );
  if (result < 0) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<List<int>>(
    invocation.id,
    _i7.FfiHelpers.extractPointerList(
      data,
      dataSize,
      (p) => p.address,
    ),
  );
}

_i1.MethodResult _etebase_collection_list_response_is_done(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseCollectionListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_list_response_is_done(this_);
  return _i1.MethodResult.successTyped<bool>(
    invocation.id,
    result,
  );
}

_i1.MethodResult _etebase_collection_list_response_get_removed_memberships(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseCollectionListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  final dataSize = libEtebase
      .etebase_collection_list_response_get_removed_memberships_length(this_);
  final data = arena<_i6.Pointer<_i2.EtebaseRemovedCollection>>(dataSize);
  final result =
      libEtebase.etebase_collection_list_response_get_removed_memberships(
    this_,
    data,
  );
  if (result < 0) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<List<int>>(
    invocation.id,
    _i7.FfiHelpers.extractPointerList(
      data,
      dataSize,
      (p) => p.address,
    ),
  );
}

_i1.MethodResult _etebase_collection_list_response_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseCollectionListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  libEtebase.etebase_collection_list_response_destroy(this_);
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_invitation_manager_list_incoming(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is int?,
      'Parameter fetchOptions must be of type int?');
  final this_ = _i6.Pointer<_i2.EtebaseCollectionInvitationManager>.fromAddress(
      (invocation.arguments[0] as int));
  final fetchOptions_address = (invocation.arguments[1] as int?);
  final fetchOptions = fetchOptions_address == null
      ? _i6.nullptr
      : _i6.Pointer<_i2.EtebaseFetchOptions>.fromAddress(fetchOptions_address);
  final result = libEtebase.etebase_invitation_manager_list_incoming(
    this_,
    fetchOptions,
  );
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<int>(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_invitation_manager_list_outgoing(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is int?,
      'Parameter fetchOptions must be of type int?');
  final this_ = _i6.Pointer<_i2.EtebaseCollectionInvitationManager>.fromAddress(
      (invocation.arguments[0] as int));
  final fetchOptions_address = (invocation.arguments[1] as int?);
  final fetchOptions = fetchOptions_address == null
      ? _i6.nullptr
      : _i6.Pointer<_i2.EtebaseFetchOptions>.fromAddress(fetchOptions_address);
  final result = libEtebase.etebase_invitation_manager_list_outgoing(
    this_,
    fetchOptions,
  );
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<int>(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_invitation_manager_accept(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is int,
      'Parameter invitation must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseCollectionInvitationManager>.fromAddress(
      (invocation.arguments[0] as int));
  final invitation = _i6.Pointer<_i2.EtebaseSignedInvitation>.fromAddress(
      (invocation.arguments[1] as int));
  final result = libEtebase.etebase_invitation_manager_accept(
    this_,
    invitation,
  );
  if (result < 0) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_invitation_manager_reject(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is int,
      'Parameter invitation must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseCollectionInvitationManager>.fromAddress(
      (invocation.arguments[0] as int));
  final invitation = _i6.Pointer<_i2.EtebaseSignedInvitation>.fromAddress(
      (invocation.arguments[1] as int));
  final result = libEtebase.etebase_invitation_manager_reject(
    this_,
    invitation,
  );
  if (result < 0) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_invitation_manager_fetch_user_profile(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is String,
      'Parameter username must be of type String');
  final this_ = _i6.Pointer<_i2.EtebaseCollectionInvitationManager>.fromAddress(
      (invocation.arguments[0] as int));
  final username = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i6.Char>();
  final result = libEtebase.etebase_invitation_manager_fetch_user_profile(
    this_,
    username,
  );
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<int>(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_invitation_manager_invite(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 5,
      'Invocation must have exactly 5 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is int,
      'Parameter collection must be of type int');
  assert(invocation.arguments[2] is String,
      'Parameter username must be of type String');
  assert(invocation.arguments[3] is _i8.TransferableTypedData,
      'Parameter pubkey must be of type TransferableTypedData');
  assert(invocation.arguments[4] is _i9.EtebaseCollectionAccessLevel,
      'Parameter accessLevel must be of type EtebaseCollectionAccessLevel');
  final this_ = _i6.Pointer<_i2.EtebaseCollectionInvitationManager>.fromAddress(
      (invocation.arguments[0] as int));
  final collection = _i6.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[1] as int));
  final username = (invocation.arguments[2] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i6.Char>();
  final pubkey_buffer = (invocation.arguments[3] as _i8.TransferableTypedData)
      .materialize()
      .asUint8List();
  final pubkeySize = pubkey_buffer.length;
  final pubkey = arena<_i6.Uint8>(pubkeySize);
  pubkey.asTypedList(pubkeySize).setAll(
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
    pubkeySize,
    accessLevel,
  );
  if (result < 0) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_invitation_manager_disinvite(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is int,
      'Parameter invitation must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseCollectionInvitationManager>.fromAddress(
      (invocation.arguments[0] as int));
  final invitation = _i6.Pointer<_i2.EtebaseSignedInvitation>.fromAddress(
      (invocation.arguments[1] as int));
  final result = libEtebase.etebase_invitation_manager_disinvite(
    this_,
    invitation,
  );
  if (result < 0) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_invitation_manager_get_pubkey(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseCollectionInvitationManager>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_invitation_manager_get_pubkey(this_);
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<_i8.TransferableTypedData>(
    invocation.id,
    _i8.TransferableTypedData.fromList([
      result.cast<_i6.Uint8>().asTypedList(
          libEtebase.etebase_invitation_manager_get_pubkey_size(this_))
    ]),
  );
}

_i1.MethodResult _etebase_invitation_manager_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseCollectionInvitationManager>.fromAddress(
      (invocation.arguments[0] as int));
  libEtebase.etebase_invitation_manager_destroy(this_);
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_collection_clone(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_clone(this_);
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<int>(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_collection_verify(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_verify(this_);
  return _i1.MethodResult.successTyped<bool>(
    invocation.id,
    result,
  );
}

_i1.MethodResult _etebase_collection_set_meta(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is int, 'Parameter meta must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final meta = _i6.Pointer<_i2.EtebaseItemMetadata>.fromAddress(
      (invocation.arguments[1] as int));
  final result = libEtebase.etebase_collection_set_meta(
    this_,
    meta,
  );
  if (result < 0) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_collection_get_meta(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_get_meta(this_);
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<int>(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_collection_set_meta_raw(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is _i8.TransferableTypedData,
      'Parameter meta must be of type TransferableTypedData');
  final this_ = _i6.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final meta_buffer = (invocation.arguments[1] as _i8.TransferableTypedData)
      .materialize()
      .asUint8List();
  final metaSize = meta_buffer.length;
  final meta = arena<_i6.Uint8>(metaSize);
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
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_collection_get_meta_raw(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena, {
  int? reinvokedWithSize,
}) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is int?,
      'Parameter sizeHint must be of type int?');
  final this_ = _i6.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final bufSize = reinvokedWithSize ??
      (invocation.arguments[1] as int?) ??
      config.defaultContentBufferSize;
  final buf = arena<_i6.Uint8>(bufSize);
  final result = libEtebase.etebase_collection_get_meta_raw(
    this_,
    buf.cast(),
    bufSize,
  );
  if (result < 0) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  } else if (result <= bufSize) {
    return _i1.MethodResult.successTyped<_i8.TransferableTypedData>(
      invocation.id,
      _i8.TransferableTypedData.fromList(
          [buf.cast<_i6.Uint8>().asTypedList(result)]),
    );
  } else if (reinvokedWithSize != null) {
    return _i1.MethodResult.failure(
      invocation.id,
      _i10.EtebaseErrorCode.generic,
      'output size of etebase_collection_get_meta_raw changed during invocation',
    );
  } else {
    return _etebase_collection_get_meta_raw(
      libEtebase,
      config,
      invocation,
      arena,
      reinvokedWithSize: result,
    );
  }
}

_i1.MethodResult _etebase_collection_set_content(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is _i8.TransferableTypedData,
      'Parameter content must be of type TransferableTypedData');
  final this_ = _i6.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final content_buffer = (invocation.arguments[1] as _i8.TransferableTypedData)
      .materialize()
      .asUint8List();
  final contentSize = content_buffer.length;
  final content = arena<_i6.Uint8>(contentSize);
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
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_collection_get_content(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena, {
  int? reinvokedWithSize,
}) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is int?,
      'Parameter sizeHint must be of type int?');
  final this_ = _i6.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final bufSize = reinvokedWithSize ??
      (invocation.arguments[1] as int?) ??
      config.defaultContentBufferSize;
  final buf = arena<_i6.Uint8>(bufSize);
  final result = libEtebase.etebase_collection_get_content(
    this_,
    buf.cast(),
    bufSize,
  );
  if (result < 0) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  } else if (result <= bufSize) {
    return _i1.MethodResult.successTyped<_i8.TransferableTypedData>(
      invocation.id,
      _i8.TransferableTypedData.fromList(
          [buf.cast<_i6.Uint8>().asTypedList(result)]),
    );
  } else if (reinvokedWithSize != null) {
    return _i1.MethodResult.failure(
      invocation.id,
      _i10.EtebaseErrorCode.generic,
      'output size of etebase_collection_get_content changed during invocation',
    );
  } else {
    return _etebase_collection_get_content(
      libEtebase,
      config,
      invocation,
      arena,
      reinvokedWithSize: result,
    );
  }
}

_i1.MethodResult _etebase_collection_delete(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_delete(this_);
  if (result < 0) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_collection_is_deleted(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_is_deleted(this_);
  return _i1.MethodResult.successTyped<bool>(
    invocation.id,
    result,
  );
}

_i1.MethodResult _etebase_collection_get_uid(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_get_uid(this_);
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<String>(
    invocation.id,
    result.cast<_i5.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_collection_get_etag(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_get_etag(this_);
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<String>(
    invocation.id,
    result.cast<_i5.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_collection_get_stoken(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_get_stoken(this_);
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<String>(
    invocation.id,
    result.cast<_i5.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_collection_as_item(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_as_item(this_);
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<int>(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_collection_get_collection_type(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_get_collection_type(this_);
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<String>(
    invocation.id,
    result.cast<_i5.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_collection_get_access_level(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_collection_get_access_level(this_);
  if (result < 0) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<_i9.EtebaseCollectionAccessLevel>(
    invocation.id,
    _i9.EtebaseCollectionAccessLevel.values[result],
  );
}

_i1.MethodResult _etebase_collection_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  libEtebase.etebase_collection_destroy(this_);
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_client_new(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is String,
      'Parameter clientName must be of type String');
  assert(invocation.arguments[1] is Uri,
      'Parameter serverUrl must be of type Uri');
  final clientName = (invocation.arguments[0] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i6.Char>();
  final serverUrl = (invocation.arguments[1] as Uri)
      .toString()
      .toNativeUtf8(allocator: arena)
      .cast<_i6.Char>();
  final result = libEtebase.etebase_client_new(
    clientName,
    serverUrl,
  );
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<int>(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_client_set_server_url(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is Uri,
      'Parameter serverUrl must be of type Uri');
  final this_ = _i6.Pointer<_i2.EtebaseClient>.fromAddress(
      (invocation.arguments[0] as int));
  final serverUrl = (invocation.arguments[1] as Uri)
      .toString()
      .toNativeUtf8(allocator: arena)
      .cast<_i6.Char>();
  final result = libEtebase.etebase_client_set_server_url(
    this_,
    serverUrl,
  );
  if (result < 0) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_client_check_etebase_server(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(
      invocation.arguments[0] is int, 'Parameter client must be of type int');
  final client = _i6.Pointer<_i2.EtebaseClient>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_client_check_etebase_server(client);
  if (result < 0) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<bool>(
    invocation.id,
    result == 0,
  );
}

_i1.MethodResult _etebase_client_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseClient>.fromAddress(
      (invocation.arguments[0] as int));
  libEtebase.etebase_client_destroy(this_);
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_account_login(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  assert(
      invocation.arguments[0] is int, 'Parameter client must be of type int');
  assert(invocation.arguments[1] is String,
      'Parameter username must be of type String');
  assert(invocation.arguments[2] is String,
      'Parameter password must be of type String');
  final client = _i6.Pointer<_i2.EtebaseClient>.fromAddress(
      (invocation.arguments[0] as int));
  final username = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i6.Char>();
  final password = (invocation.arguments[2] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i6.Char>();
  final result = libEtebase.etebase_account_login(
    client,
    username,
    password,
  );
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<int>(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_account_signup(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  assert(
      invocation.arguments[0] is int, 'Parameter client must be of type int');
  assert(invocation.arguments[1] is int, 'Parameter user must be of type int');
  assert(invocation.arguments[2] is String,
      'Parameter password must be of type String');
  final client = _i6.Pointer<_i2.EtebaseClient>.fromAddress(
      (invocation.arguments[0] as int));
  final user = _i6.Pointer<_i2.EtebaseUser>.fromAddress(
      (invocation.arguments[1] as int));
  final password = (invocation.arguments[2] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i6.Char>();
  final result = libEtebase.etebase_account_signup(
    client,
    user,
    password,
  );
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<int>(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_account_fetch_token(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseAccount>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_account_fetch_token(this_);
  if (result < 0) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_account_fetch_dashboard_url(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseAccount>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_account_fetch_dashboard_url(this_);
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<Uri>(
    invocation.id,
    Uri.parse(result.cast<_i5.Utf8>().toDartString()),
  );
}

_i1.MethodResult _etebase_account_force_server_url(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is Uri,
      'Parameter serverUrl must be of type Uri');
  final this_ = _i6.Pointer<_i2.EtebaseAccount>.fromAddress(
      (invocation.arguments[0] as int));
  final serverUrl = (invocation.arguments[1] as Uri)
      .toString()
      .toNativeUtf8(allocator: arena)
      .cast<_i6.Char>();
  final result = libEtebase.etebase_account_force_server_url(
    this_,
    serverUrl,
  );
  if (result < 0) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_account_change_password(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is String,
      'Parameter password must be of type String');
  final this_ = _i6.Pointer<_i2.EtebaseAccount>.fromAddress(
      (invocation.arguments[0] as int));
  final password = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i6.Char>();
  final result = libEtebase.etebase_account_change_password(
    this_,
    password,
  );
  if (result < 0) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_account_logout(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseAccount>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_account_logout(this_);
  if (result < 0) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _etebase_account_get_collection_manager(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseAccount>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_account_get_collection_manager(this_);
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<int>(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_account_get_invitation_manager(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseAccount>.fromAddress(
      (invocation.arguments[0] as int));
  final result = libEtebase.etebase_account_get_invitation_manager(this_);
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<int>(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_account_save(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  assert(invocation.arguments[1] is _i8.TransferableTypedData?,
      'Parameter encryptionKey must be of type TransferableTypedData?');
  final this_ = _i6.Pointer<_i2.EtebaseAccount>.fromAddress(
      (invocation.arguments[0] as int));
  final encryptionKey_buffer =
      (invocation.arguments[1] as _i8.TransferableTypedData?)
          ?.materialize()
          .asUint8List();
  final encryptionKeySize = encryptionKey_buffer?.length ?? 0;
  final encryptionKey = encryptionKey_buffer == null
      ? _i6.nullptr
      : arena<_i6.Uint8>(encryptionKeySize);
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
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<String>(
    invocation.id,
    result.cast<_i5.Utf8>().toDartString(),
  );
}

_i1.MethodResult _etebase_account_restore(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  assert(
      invocation.arguments[0] is int, 'Parameter client must be of type int');
  assert(invocation.arguments[1] is String,
      'Parameter accountDataStored must be of type String');
  assert(invocation.arguments[2] is _i8.TransferableTypedData?,
      'Parameter encryptionKey must be of type TransferableTypedData?');
  final client = _i6.Pointer<_i2.EtebaseClient>.fromAddress(
      (invocation.arguments[0] as int));
  final accountDataStored = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: arena)
      .cast<_i6.Char>();
  final encryptionKey_buffer =
      (invocation.arguments[2] as _i8.TransferableTypedData?)
          ?.materialize()
          .asUint8List();
  final encryptionKeySize = encryptionKey_buffer?.length ?? 0;
  final encryptionKey = encryptionKey_buffer == null
      ? _i6.nullptr
      : arena<_i6.Uint8>(encryptionKeySize);
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
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<int>(
    invocation.id,
    result.address,
  );
}

_i1.MethodResult _etebase_account_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter this_ must be of type int');
  final this_ = _i6.Pointer<_i2.EtebaseAccount>.fromAddress(
      (invocation.arguments[0] as int));
  libEtebase.etebase_account_destroy(this_);
  return _i1.MethodResult.successTyped<void>(
    invocation.id,
    null,
  );
}

_i1.MethodResult _ETEBASE_UTILS_PRETTY_FINGERPRINT_SIZE(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 0,
      'Invocation must have exactly 0 arguments');
  final result = libEtebase.ETEBASE_UTILS_PRETTY_FINGERPRINT_SIZE;
  if (result < 0) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<int>(
    invocation.id,
    result,
  );
}

_i1.MethodResult _etebase_utils_randombytes(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is int, 'Parameter size must be of type int');
  final size = (invocation.arguments[0] as int);
  final buf = arena<_i6.Uint8>(size);
  final result = libEtebase.etebase_utils_randombytes(
    buf.cast(),
    size,
  );
  if (result < 0) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<_i8.TransferableTypedData>(
    invocation.id,
    _i8.TransferableTypedData.fromList(
        [buf.cast<_i6.Uint8>().asTypedList(size)]),
  );
}

_i1.MethodResult _etebase_utils_pretty_fingerprint(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  assert(invocation.arguments[0] is _i8.TransferableTypedData,
      'Parameter content must be of type TransferableTypedData');
  final content_buffer = (invocation.arguments[0] as _i8.TransferableTypedData)
      .materialize()
      .asUint8List();
  final contentSize = content_buffer.length;
  final content = arena<_i6.Uint8>(contentSize);
  content.asTypedList(contentSize).setAll(
        0,
        content_buffer,
      );
  final buf = arena<_i6.Char>(libEtebase.ETEBASE_UTILS_PRETTY_FINGERPRINT_SIZE);
  final result = libEtebase.etebase_utils_pretty_fingerprint(
    content.cast(),
    contentSize,
    buf,
  );
  if (result < 0) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<String>(
    invocation.id,
    buf
        .cast<_i5.Utf8>()
        .toDartString(length: libEtebase.ETEBASE_UTILS_PRETTY_FINGERPRINT_SIZE),
  );
}

_i1.MethodResult _etebase_get_default_server_url(
  _i2.LibEtebaseFFI libEtebase,
  _i3.EtebaseConfig config,
  _i4.MethodInvocation invocation,
  _i5.Arena arena,
) {
  assert(invocation.arguments.length == 0,
      'Invocation must have exactly 0 arguments');
  final result = libEtebase.etebase_get_default_server_url();
  if (result == _i6.nullptr) {
    return _i7.FfiHelpers.errorResult(
      libEtebase,
      invocation.id,
    );
  }
  return _i1.MethodResult.successTyped<Uri>(
    invocation.id,
    Uri.parse(result.cast<_i5.Utf8>().toDartString()),
  );
}
