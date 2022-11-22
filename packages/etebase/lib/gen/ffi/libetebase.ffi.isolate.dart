// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// EtebaseIsolateGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, require_trailing_commas, cast_nullable_to_non_nullable, unnecessary_parenthesis, prefer_relative_imports, lines_longer_than_80_chars, prefer_is_empty
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:ffi' as _i5;
import 'dart:typed_data' as _i6;

import 'package:collection/collection.dart';
import 'package:etebase/gen/ffi/libetebase.ffi.dart' as _i2;
import 'package:etebase/src/isolate/method_invocation.dart' as _i3;
import 'package:etebase/src/isolate/method_result.dart' as _i1;
import 'package:etebase/src/model/etebase_collection_access_level.dart' as _i8;
import 'package:etebase/src/model/etebase_prefetch_option.dart' as _i7;
import 'package:ffi/ffi.dart' as _i4;
import 'package:ffi/ffi.dart';

_i1.MethodResult etebaseIsolateMessageHandler(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
) {
  final alloc = _i4.Arena();
  try {
    switch (invocation.method) {
      case #etebase_user_profile_get_pubkey:
        return _etebase_user_profile_get_pubkey(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_user_profile_destroy:
        return _etebase_user_profile_destroy(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_user_new:
        return _etebase_user_new(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_user_set_username:
        return _etebase_user_set_username(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_user_get_username:
        return _etebase_user_get_username(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_user_set_email:
        return _etebase_user_set_email(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_user_get_email:
        return _etebase_user_get_email(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_user_destroy:
        return _etebase_user_destroy(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_signed_invitation_clone:
        return _etebase_signed_invitation_clone(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_signed_invitation_get_uid:
        return _etebase_signed_invitation_get_uid(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_signed_invitation_get_username:
        return _etebase_signed_invitation_get_username(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_signed_invitation_get_collection:
        return _etebase_signed_invitation_get_collection(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_signed_invitation_get_access_level:
        return _etebase_signed_invitation_get_access_level(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_signed_invitation_get_from_username:
        return _etebase_signed_invitation_get_from_username(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_signed_invitation_get_from_pubkey:
        return _etebase_signed_invitation_get_from_pubkey(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_signed_invitation_destroy:
        return _etebase_signed_invitation_destroy(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_removed_collection_get_uid:
        return _etebase_removed_collection_get_uid(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_removed_collection_destroy:
        return _etebase_removed_collection_destroy(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_invitation_list_response_get_iterator:
        return _etebase_invitation_list_response_get_iterator(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_invitation_list_response_get_data:
        return _etebase_invitation_list_response_get_data(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_invitation_list_response_is_done:
        return _etebase_invitation_list_response_is_done(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_invitation_list_response_destroy:
        return _etebase_invitation_list_response_destroy(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_item_revisions_list_response_get_iterator:
        return _etebase_item_revisions_list_response_get_iterator(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_item_revisions_list_response_get_data:
        return _etebase_item_revisions_list_response_get_data(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_item_revisions_list_response_is_done:
        return _etebase_item_revisions_list_response_is_done(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_item_revisions_list_response_destroy:
        return _etebase_item_revisions_list_response_destroy(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_member_list_response_get_iterator:
        return _etebase_member_list_response_get_iterator(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_member_list_response_get_data:
        return _etebase_member_list_response_get_data(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_member_list_response_is_done:
        return _etebase_member_list_response_is_done(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_member_list_response_destroy:
        return _etebase_member_list_response_destroy(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_item_metadata_new:
        return _etebase_item_metadata_new(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_item_metadata_set_item_type:
        return _etebase_item_metadata_set_item_type(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_item_metadata_get_item_type:
        return _etebase_item_metadata_get_item_type(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_item_metadata_set_name:
        return _etebase_item_metadata_set_name(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_item_metadata_get_name:
        return _etebase_item_metadata_get_name(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_item_metadata_set_mtime:
        return _etebase_item_metadata_set_mtime(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_item_metadata_get_mtime:
        return _etebase_item_metadata_get_mtime(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_item_metadata_set_description:
        return _etebase_item_metadata_set_description(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_item_metadata_get_description:
        return _etebase_item_metadata_get_description(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_item_metadata_set_color:
        return _etebase_item_metadata_set_color(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_item_metadata_get_color:
        return _etebase_item_metadata_get_color(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_item_metadata_destroy:
        return _etebase_item_metadata_destroy(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_item_manager_fetch:
        return _etebase_item_manager_fetch(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_item_manager_create:
        return _etebase_item_manager_create(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_item_manager_create_raw:
        return _etebase_item_manager_create_raw(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_item_manager_list:
        return _etebase_item_manager_list(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_item_manager_item_revisions:
        return _etebase_item_manager_item_revisions(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_item_manager_fetch_updates:
        return _etebase_item_manager_fetch_updates(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_item_manager_fetch_multi:
        return _etebase_item_manager_fetch_multi(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_item_manager_batch:
        return _etebase_item_manager_batch(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_item_manager_batch_deps:
        return _etebase_item_manager_batch_deps(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_item_manager_transaction:
        return _etebase_item_manager_transaction(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_item_manager_transaction_deps:
        return _etebase_item_manager_transaction_deps(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_item_manager_cache_load:
        return _etebase_item_manager_cache_load(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_item_manager_cache_save:
        return _etebase_item_manager_cache_save(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_item_manager_cache_save_with_content:
        return _etebase_item_manager_cache_save_with_content(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_item_manager_destroy:
        return _etebase_item_manager_destroy(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_item_list_response_get_stoken:
        return _etebase_item_list_response_get_stoken(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_item_list_response_get_data:
        return _etebase_item_list_response_get_data(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_item_list_response_is_done:
        return _etebase_item_list_response_is_done(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_item_list_response_destroy:
        return _etebase_item_list_response_destroy(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_item_clone:
        return _etebase_item_clone(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_item_verify:
        return _etebase_item_verify(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_item_set_meta:
        return _etebase_item_set_meta(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_item_get_meta:
        return _etebase_item_get_meta(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_item_set_meta_raw:
        return _etebase_item_set_meta_raw(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_item_get_meta_raw:
        return _etebase_item_get_meta_raw(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_item_set_content:
        return _etebase_item_set_content(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_item_get_content:
        return _etebase_item_get_content(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_item_delete:
        return _etebase_item_delete(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_item_is_deleted:
        return _etebase_item_is_deleted(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_item_get_uid:
        return _etebase_item_get_uid(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_item_get_etag:
        return _etebase_item_get_etag(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_item_destroy:
        return _etebase_item_destroy(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_fs_cache_new:
        return _etebase_fs_cache_new(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_fs_cache_clear_user:
        return _etebase_fs_cache_clear_user(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_fs_cache_save_account:
        return _etebase_fs_cache_save_account(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_fs_cache_load_account:
        return _etebase_fs_cache_load_account(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_fs_cache_save_stoken:
        return _etebase_fs_cache_save_stoken(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_fs_cache_load_stoken:
        return _etebase_fs_cache_load_stoken(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_fs_cache_collection_save_stoken:
        return _etebase_fs_cache_collection_save_stoken(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_fs_cache_collection_load_stoken:
        return _etebase_fs_cache_collection_load_stoken(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_fs_cache_collection_set:
        return _etebase_fs_cache_collection_set(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_fs_cache_collection_unset:
        return _etebase_fs_cache_collection_unset(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_fs_cache_collection_get:
        return _etebase_fs_cache_collection_get(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_fs_cache_item_set:
        return _etebase_fs_cache_item_set(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_fs_cache_item_unset:
        return _etebase_fs_cache_item_unset(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_fs_cache_item_get:
        return _etebase_fs_cache_item_get(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_fs_cache_destroy:
        return _etebase_fs_cache_destroy(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_fetch_options_new:
        return _etebase_fetch_options_new(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_fetch_options_set_limit:
        return _etebase_fetch_options_set_limit(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_fetch_options_set_prefetch:
        return _etebase_fetch_options_set_prefetch(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_fetch_options_set_with_collection:
        return _etebase_fetch_options_set_with_collection(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_fetch_options_set_iterator:
        return _etebase_fetch_options_set_iterator(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_fetch_options_set_stoken:
        return _etebase_fetch_options_set_stoken(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_fetch_options_destroy:
        return _etebase_fetch_options_destroy(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_collection_member_manager_list:
        return _etebase_collection_member_manager_list(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_collection_member_manager_remove:
        return _etebase_collection_member_manager_remove(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_collection_member_manager_leave:
        return _etebase_collection_member_manager_leave(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_collection_member_manager_modify_access_level:
        return _etebase_collection_member_manager_modify_access_level(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_collection_member_manager_destroy:
        return _etebase_collection_member_manager_destroy(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_collection_member_clone:
        return _etebase_collection_member_clone(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_collection_member_get_username:
        return _etebase_collection_member_get_username(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_collection_member_get_access_level:
        return _etebase_collection_member_get_access_level(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_collection_member_destroy:
        return _etebase_collection_member_destroy(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_collection_manager_fetch:
        return _etebase_collection_manager_fetch(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_collection_manager_create:
        return _etebase_collection_manager_create(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_collection_manager_create_raw:
        return _etebase_collection_manager_create_raw(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_collection_manager_get_item_manager:
        return _etebase_collection_manager_get_item_manager(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_collection_manager_list:
        return _etebase_collection_manager_list(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_collection_manager_list_multi:
        return _etebase_collection_manager_list_multi(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_collection_manager_upload:
        return _etebase_collection_manager_upload(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_collection_manager_transaction:
        return _etebase_collection_manager_transaction(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_collection_manager_cache_load:
        return _etebase_collection_manager_cache_load(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_collection_manager_cache_save:
        return _etebase_collection_manager_cache_save(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_collection_manager_cache_save_with_content:
        return _etebase_collection_manager_cache_save_with_content(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_collection_manager_get_member_manager:
        return _etebase_collection_manager_get_member_manager(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_collection_manager_destroy:
        return _etebase_collection_manager_destroy(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_collection_list_response_get_stoken:
        return _etebase_collection_list_response_get_stoken(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_collection_list_response_get_data:
        return _etebase_collection_list_response_get_data(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_collection_list_response_is_done:
        return _etebase_collection_list_response_is_done(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_collection_list_response_get_removed_memberships:
        return _etebase_collection_list_response_get_removed_memberships(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_collection_list_response_destroy:
        return _etebase_collection_list_response_destroy(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_invitation_manager_list_incoming:
        return _etebase_invitation_manager_list_incoming(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_invitation_manager_list_outgoing:
        return _etebase_invitation_manager_list_outgoing(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_invitation_manager_accept:
        return _etebase_invitation_manager_accept(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_invitation_manager_reject:
        return _etebase_invitation_manager_reject(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_invitation_manager_fetch_user_profile:
        return _etebase_invitation_manager_fetch_user_profile(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_invitation_manager_invite:
        return _etebase_invitation_manager_invite(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_invitation_manager_disinvite:
        return _etebase_invitation_manager_disinvite(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_invitation_manager_get_pubkey:
        return _etebase_invitation_manager_get_pubkey(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_invitation_manager_destroy:
        return _etebase_invitation_manager_destroy(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_collection_clone:
        return _etebase_collection_clone(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_collection_verify:
        return _etebase_collection_verify(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_collection_set_meta:
        return _etebase_collection_set_meta(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_collection_get_meta:
        return _etebase_collection_get_meta(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_collection_set_meta_raw:
        return _etebase_collection_set_meta_raw(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_collection_get_meta_raw:
        return _etebase_collection_get_meta_raw(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_collection_set_content:
        return _etebase_collection_set_content(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_collection_get_content:
        return _etebase_collection_get_content(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_collection_delete:
        return _etebase_collection_delete(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_collection_is_deleted:
        return _etebase_collection_is_deleted(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_collection_get_uid:
        return _etebase_collection_get_uid(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_collection_get_etag:
        return _etebase_collection_get_etag(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_collection_get_stoken:
        return _etebase_collection_get_stoken(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_collection_as_item:
        return _etebase_collection_as_item(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_collection_get_collection_type:
        return _etebase_collection_get_collection_type(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_collection_get_access_level:
        return _etebase_collection_get_access_level(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_collection_destroy:
        return _etebase_collection_destroy(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_client_new:
        return _etebase_client_new(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_client_set_server_url:
        return _etebase_client_set_server_url(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_client_check_etebase_server:
        return _etebase_client_check_etebase_server(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_client_destroy:
        return _etebase_client_destroy(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_account_login:
        return _etebase_account_login(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_account_signup:
        return _etebase_account_signup(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_account_fetch_token:
        return _etebase_account_fetch_token(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_account_fetch_dashboard_url:
        return _etebase_account_fetch_dashboard_url(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_account_force_server_url:
        return _etebase_account_force_server_url(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_account_change_password:
        return _etebase_account_change_password(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_account_logout:
        return _etebase_account_logout(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_account_get_collection_manager:
        return _etebase_account_get_collection_manager(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_account_get_invitation_manager:
        return _etebase_account_get_invitation_manager(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_account_save:
        return _etebase_account_save(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_account_restore:
        return _etebase_account_restore(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_account_destroy:
        return _etebase_account_destroy(
          libEtebase,
          invocation,
          alloc,
        );
      case #ETEBASE_UTILS_PRETTY_FINGERPRINT_SIZE:
        return _ETEBASE_UTILS_PRETTY_FINGERPRINT_SIZE(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_utils_randombytes:
        return _etebase_utils_randombytes(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_utils_pretty_fingerprint:
        return _etebase_utils_pretty_fingerprint(
          libEtebase,
          invocation,
          alloc,
        );
      case #etebase_get_default_server_url:
        return _etebase_get_default_server_url(
          libEtebase,
          invocation,
          alloc,
        );
      default:
        throw ArgumentError.value(
          invocation.method,
          'invocation.method',
          'Method does not exist',
        );
    }
  } finally {
    alloc.releaseAll();
  }
}

_i1.MethodResult _etebase_user_profile_get_pubkey(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseUserProfile>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_user_profile_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseUserProfile>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_user_new(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final username = (invocation.arguments[0] as String)
      .toNativeUtf8(allocator: alloc)
      .cast<_i5.Char>();
  final email = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: alloc)
      .cast<_i5.Char>();
  throw UnimplementedError();
}

_i1.MethodResult _etebase_user_set_username(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseUser>.fromAddress(
      (invocation.arguments[0] as int));
  final username = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: alloc)
      .cast<_i5.Char>();
  throw UnimplementedError();
}

_i1.MethodResult _etebase_user_get_username(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseUser>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_user_set_email(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseUser>.fromAddress(
      (invocation.arguments[0] as int));
  final email = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: alloc)
      .cast<_i5.Char>();
  throw UnimplementedError();
}

_i1.MethodResult _etebase_user_get_email(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseUser>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_user_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseUser>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_signed_invitation_clone(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseSignedInvitation>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_signed_invitation_get_uid(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseSignedInvitation>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_signed_invitation_get_username(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseSignedInvitation>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_signed_invitation_get_collection(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseSignedInvitation>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_signed_invitation_get_access_level(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseSignedInvitation>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_signed_invitation_get_from_username(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseSignedInvitation>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_signed_invitation_get_from_pubkey(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseSignedInvitation>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_signed_invitation_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseSignedInvitation>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_removed_collection_get_uid(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseRemovedCollection>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_removed_collection_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseRemovedCollection>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_invitation_list_response_get_iterator(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseInvitationListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_invitation_list_response_get_data(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseInvitationListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_invitation_list_response_is_done(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseInvitationListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_invitation_list_response_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseInvitationListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_revisions_list_response_get_iterator(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemRevisionsListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_revisions_list_response_get_data(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemRevisionsListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_revisions_list_response_is_done(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemRevisionsListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_revisions_list_response_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemRevisionsListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_member_list_response_get_iterator(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseMemberListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_member_list_response_get_data(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseMemberListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_member_list_response_is_done(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseMemberListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_member_list_response_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseMemberListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_metadata_new(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 0,
      'Invocation must have exactly 0 arguments');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_metadata_set_item_type(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemMetadata>.fromAddress(
      (invocation.arguments[0] as int));
  final itemType = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: alloc)
      .cast<_i5.Char>();
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_metadata_get_item_type(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemMetadata>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_metadata_set_name(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemMetadata>.fromAddress(
      (invocation.arguments[0] as int));
  final name = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: alloc)
      .cast<_i5.Char>();
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_metadata_get_name(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemMetadata>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_metadata_set_mtime(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemMetadata>.fromAddress(
      (invocation.arguments[0] as int));
  final mtime = alloc<_i5.Int64>()
    ..value = (invocation.arguments[1] as DateTime).millisecondsSinceEpoch;
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_metadata_get_mtime(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemMetadata>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_metadata_set_description(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemMetadata>.fromAddress(
      (invocation.arguments[0] as int));
  final description = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: alloc)
      .cast<_i5.Char>();
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_metadata_get_description(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemMetadata>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_metadata_set_color(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemMetadata>.fromAddress(
      (invocation.arguments[0] as int));
  final color = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: alloc)
      .cast<_i5.Char>();
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_metadata_get_color(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemMetadata>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_metadata_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemMetadata>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_manager_fetch(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final itemUid = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: alloc)
      .cast<_i5.Char>();
  final fetchOptions = _i5.Pointer<_i2.EtebaseFetchOptions>.fromAddress(
      (invocation.arguments[2] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_manager_create(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final meta = _i5.Pointer<_i2.EtebaseItemMetadata>.fromAddress(
      (invocation.arguments[1] as int));
  final content_size = (invocation.arguments[2] as _i6.Uint8List).length;
  final content = alloc<_i5.Uint8>(content_size);
  content.asTypedList(content_size).setAll(
        0,
        (invocation.arguments[2] as _i6.Uint8List),
      );
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_manager_create_raw(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final meta_size = (invocation.arguments[1] as _i6.Uint8List).length;
  final meta = alloc<_i5.Uint8>(meta_size);
  meta.asTypedList(meta_size).setAll(
        0,
        (invocation.arguments[1] as _i6.Uint8List),
      );
  final content_size = (invocation.arguments[2] as _i6.Uint8List).length;
  final content = alloc<_i5.Uint8>(content_size);
  content.asTypedList(content_size).setAll(
        0,
        (invocation.arguments[2] as _i6.Uint8List),
      );
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_manager_list(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final fetchOptions = _i5.Pointer<_i2.EtebaseFetchOptions>.fromAddress(
      (invocation.arguments[1] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_manager_item_revisions(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final item = _i5.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[1] as int));
  final fetchOptions = _i5.Pointer<_i2.EtebaseFetchOptions>.fromAddress(
      (invocation.arguments[2] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_manager_fetch_updates(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final items = (invocation.arguments[1] as List<int>);
  final fetchOptions = _i5.Pointer<_i2.EtebaseFetchOptions>.fromAddress(
      (invocation.arguments[2] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_manager_fetch_multi(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final items_size = (invocation.arguments[1] as List<String>).length;
  final items = alloc<_i5.Pointer<_i5.Char>>(items_size);
  (invocation.arguments[1] as List<String>)
      .map((e) => e.toNativeUtf8(allocator: alloc).cast<_i5.Char>())
      .forEachIndexed((
        i,
        e,
      ) =>
          items[i] = e);
  final fetchOptions = _i5.Pointer<_i2.EtebaseFetchOptions>.fromAddress(
      (invocation.arguments[2] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_manager_batch(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final items = (invocation.arguments[1] as List<int>);
  final fetchOptions = _i5.Pointer<_i2.EtebaseFetchOptions>.fromAddress(
      (invocation.arguments[2] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_manager_batch_deps(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 4,
      'Invocation must have exactly 4 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final items = (invocation.arguments[1] as List<int>);
  final deps = (invocation.arguments[2] as List<int>);
  final fetchOptions = _i5.Pointer<_i2.EtebaseFetchOptions>.fromAddress(
      (invocation.arguments[3] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_manager_transaction(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final items = (invocation.arguments[1] as List<int>);
  final fetchOptions = _i5.Pointer<_i2.EtebaseFetchOptions>.fromAddress(
      (invocation.arguments[2] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_manager_transaction_deps(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 4,
      'Invocation must have exactly 4 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final items = (invocation.arguments[1] as List<int>);
  final deps = (invocation.arguments[2] as List<int>);
  final fetchOptions = _i5.Pointer<_i2.EtebaseFetchOptions>.fromAddress(
      (invocation.arguments[3] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_manager_cache_load(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final cached_size = (invocation.arguments[1] as _i6.Uint8List).length;
  final cached = alloc<_i5.Uint8>(cached_size);
  cached.asTypedList(cached_size).setAll(
        0,
        (invocation.arguments[1] as _i6.Uint8List),
      );
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_manager_cache_save(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final item = _i5.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[1] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_manager_cache_save_with_content(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  final item = _i5.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[1] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_manager_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_list_response_get_stoken(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_list_response_get_data(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_list_response_is_done(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_list_response_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItemListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_clone(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_verify(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_set_meta(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  final meta = _i5.Pointer<_i2.EtebaseItemMetadata>.fromAddress(
      (invocation.arguments[1] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_get_meta(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_set_meta_raw(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  final meta_size = (invocation.arguments[1] as _i6.Uint8List).length;
  final meta = alloc<_i5.Uint8>(meta_size);
  meta.asTypedList(meta_size).setAll(
        0,
        (invocation.arguments[1] as _i6.Uint8List),
      );
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_get_meta_raw(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_set_content(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  final content_size = (invocation.arguments[1] as _i6.Uint8List).length;
  final content = alloc<_i5.Uint8>(content_size);
  content.asTypedList(content_size).setAll(
        0,
        (invocation.arguments[1] as _i6.Uint8List),
      );
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_get_content(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_delete(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_is_deleted(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_get_uid(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_get_etag(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_item_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_fs_cache_new(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final path = (invocation.arguments[0] as String)
      .toNativeUtf8(allocator: alloc)
      .cast<_i5.Char>();
  final username = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: alloc)
      .cast<_i5.Char>();
  throw UnimplementedError();
}

_i1.MethodResult _etebase_fs_cache_clear_user(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_fs_cache_save_account(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final etebase = _i5.Pointer<_i2.EtebaseAccount>.fromAddress(
      (invocation.arguments[1] as int));
  final encryptionKey_size = (invocation.arguments[2] as _i6.Uint8List).length;
  final encryptionKey = alloc<_i5.Uint8>(encryptionKey_size);
  encryptionKey.asTypedList(encryptionKey_size).setAll(
        0,
        (invocation.arguments[2] as _i6.Uint8List),
      );
  throw UnimplementedError();
}

_i1.MethodResult _etebase_fs_cache_load_account(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final client = _i5.Pointer<_i2.EtebaseClient>.fromAddress(
      (invocation.arguments[1] as int));
  final encryptionKey_size = (invocation.arguments[2] as _i6.Uint8List).length;
  final encryptionKey = alloc<_i5.Uint8>(encryptionKey_size);
  encryptionKey.asTypedList(encryptionKey_size).setAll(
        0,
        (invocation.arguments[2] as _i6.Uint8List),
      );
  throw UnimplementedError();
}

_i1.MethodResult _etebase_fs_cache_save_stoken(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final stoken = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: alloc)
      .cast<_i5.Char>();
  throw UnimplementedError();
}

_i1.MethodResult _etebase_fs_cache_load_stoken(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_fs_cache_collection_save_stoken(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final colUid = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: alloc)
      .cast<_i5.Char>();
  final stoken = (invocation.arguments[2] as String)
      .toNativeUtf8(allocator: alloc)
      .cast<_i5.Char>();
  throw UnimplementedError();
}

_i1.MethodResult _etebase_fs_cache_collection_load_stoken(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final colUid = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: alloc)
      .cast<_i5.Char>();
  throw UnimplementedError();
}

_i1.MethodResult _etebase_fs_cache_collection_set(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final colMgr = _i5.Pointer<_i2.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[1] as int));
  final col = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[2] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_fs_cache_collection_unset(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final colMgr = _i5.Pointer<_i2.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[1] as int));
  final colUid = (invocation.arguments[2] as String)
      .toNativeUtf8(allocator: alloc)
      .cast<_i5.Char>();
  throw UnimplementedError();
}

_i1.MethodResult _etebase_fs_cache_collection_get(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final colMgr = _i5.Pointer<_i2.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[1] as int));
  final colUid = (invocation.arguments[2] as String)
      .toNativeUtf8(allocator: alloc)
      .cast<_i5.Char>();
  throw UnimplementedError();
}

_i1.MethodResult _etebase_fs_cache_item_set(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 4,
      'Invocation must have exactly 4 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final itemMgr = _i5.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[1] as int));
  final colUid = (invocation.arguments[2] as String)
      .toNativeUtf8(allocator: alloc)
      .cast<_i5.Char>();
  final item = _i5.Pointer<_i2.EtebaseItem>.fromAddress(
      (invocation.arguments[3] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_fs_cache_item_unset(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 4,
      'Invocation must have exactly 4 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final itemMgr = _i5.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[1] as int));
  final colUid = (invocation.arguments[2] as String)
      .toNativeUtf8(allocator: alloc)
      .cast<_i5.Char>();
  final itemUid = (invocation.arguments[3] as String)
      .toNativeUtf8(allocator: alloc)
      .cast<_i5.Char>();
  throw UnimplementedError();
}

_i1.MethodResult _etebase_fs_cache_item_get(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 4,
      'Invocation must have exactly 4 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  final itemMgr = _i5.Pointer<_i2.EtebaseItemManager>.fromAddress(
      (invocation.arguments[1] as int));
  final colUid = (invocation.arguments[2] as String)
      .toNativeUtf8(allocator: alloc)
      .cast<_i5.Char>();
  final itemUid = (invocation.arguments[3] as String)
      .toNativeUtf8(allocator: alloc)
      .cast<_i5.Char>();
  throw UnimplementedError();
}

_i1.MethodResult _etebase_fs_cache_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseFileSystemCache>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_fetch_options_new(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 0,
      'Invocation must have exactly 0 arguments');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_fetch_options_set_limit(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseFetchOptions>.fromAddress(
      (invocation.arguments[0] as int));
  final limit = (invocation.arguments[1] as int);
  throw UnimplementedError();
}

_i1.MethodResult _etebase_fetch_options_set_prefetch(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseFetchOptions>.fromAddress(
      (invocation.arguments[0] as int));
  final prefetch = (invocation.arguments[1] as _i7.EtebasePrefetchOption).index;
  throw UnimplementedError();
}

_i1.MethodResult _etebase_fetch_options_set_with_collection(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseFetchOptions>.fromAddress(
      (invocation.arguments[0] as int));
  final withCollection = (invocation.arguments[1] as bool);
  throw UnimplementedError();
}

_i1.MethodResult _etebase_fetch_options_set_iterator(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseFetchOptions>.fromAddress(
      (invocation.arguments[0] as int));
  final iterator = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: alloc)
      .cast<_i5.Char>();
  throw UnimplementedError();
}

_i1.MethodResult _etebase_fetch_options_set_stoken(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseFetchOptions>.fromAddress(
      (invocation.arguments[0] as int));
  final stoken = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: alloc)
      .cast<_i5.Char>();
  throw UnimplementedError();
}

_i1.MethodResult _etebase_fetch_options_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseFetchOptions>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_member_manager_list(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionMemberManager>.fromAddress(
      (invocation.arguments[0] as int));
  final fetchOptions = _i5.Pointer<_i2.EtebaseFetchOptions>.fromAddress(
      (invocation.arguments[1] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_member_manager_remove(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionMemberManager>.fromAddress(
      (invocation.arguments[0] as int));
  final username = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: alloc)
      .cast<_i5.Char>();
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_member_manager_leave(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionMemberManager>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_member_manager_modify_access_level(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionMemberManager>.fromAddress(
      (invocation.arguments[0] as int));
  final username = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: alloc)
      .cast<_i5.Char>();
  final accessLevel =
      (invocation.arguments[2] as _i8.EtebaseCollectionAccessLevel).index;
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_member_manager_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionMemberManager>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_member_clone(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionMember>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_member_get_username(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionMember>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_member_get_access_level(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionMember>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_member_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionMember>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_manager_fetch(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  final colUid = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: alloc)
      .cast<_i5.Char>();
  final fetchOptions = _i5.Pointer<_i2.EtebaseFetchOptions>.fromAddress(
      (invocation.arguments[2] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_manager_create(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 4,
      'Invocation must have exactly 4 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  final collectionType = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: alloc)
      .cast<_i5.Char>();
  final meta = _i5.Pointer<_i2.EtebaseItemMetadata>.fromAddress(
      (invocation.arguments[2] as int));
  final content_size = (invocation.arguments[3] as _i6.Uint8List).length;
  final content = alloc<_i5.Uint8>(content_size);
  content.asTypedList(content_size).setAll(
        0,
        (invocation.arguments[3] as _i6.Uint8List),
      );
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_manager_create_raw(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 4,
      'Invocation must have exactly 4 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  final collectionType = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: alloc)
      .cast<_i5.Char>();
  final meta_size = (invocation.arguments[2] as _i6.Uint8List).length;
  final meta = alloc<_i5.Uint8>(meta_size);
  meta.asTypedList(meta_size).setAll(
        0,
        (invocation.arguments[2] as _i6.Uint8List),
      );
  final content_size = (invocation.arguments[3] as _i6.Uint8List).length;
  final content = alloc<_i5.Uint8>(content_size);
  content.asTypedList(content_size).setAll(
        0,
        (invocation.arguments[3] as _i6.Uint8List),
      );
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_manager_get_item_manager(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  final col = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[1] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_manager_list(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  final collectionType = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: alloc)
      .cast<_i5.Char>();
  final fetchOptions = _i5.Pointer<_i2.EtebaseFetchOptions>.fromAddress(
      (invocation.arguments[2] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_manager_list_multi(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  final collectionTypes_size = (invocation.arguments[1] as List<String>).length;
  final collectionTypes = alloc<_i5.Pointer<_i5.Char>>(collectionTypes_size);
  (invocation.arguments[1] as List<String>)
      .map((e) => e.toNativeUtf8(allocator: alloc).cast<_i5.Char>())
      .forEachIndexed((
        i,
        e,
      ) =>
          collectionTypes[i] = e);
  final fetchOptions = _i5.Pointer<_i2.EtebaseFetchOptions>.fromAddress(
      (invocation.arguments[2] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_manager_upload(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  final collection = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[1] as int));
  final fetchOptions = _i5.Pointer<_i2.EtebaseFetchOptions>.fromAddress(
      (invocation.arguments[2] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_manager_transaction(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  final collection = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[1] as int));
  final fetchOptions = _i5.Pointer<_i2.EtebaseFetchOptions>.fromAddress(
      (invocation.arguments[2] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_manager_cache_load(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  final cached_size = (invocation.arguments[1] as _i6.Uint8List).length;
  final cached = alloc<_i5.Uint8>(cached_size);
  cached.asTypedList(cached_size).setAll(
        0,
        (invocation.arguments[1] as _i6.Uint8List),
      );
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_manager_cache_save(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  final collection = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[1] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_manager_cache_save_with_content(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  final collection = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[1] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_manager_get_member_manager(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  final col = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[1] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_manager_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionManager>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_list_response_get_stoken(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_list_response_get_data(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_list_response_is_done(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_list_response_get_removed_memberships(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_list_response_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionListResponse>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_invitation_manager_list_incoming(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionInvitationManager>.fromAddress(
      (invocation.arguments[0] as int));
  final fetchOptions = _i5.Pointer<_i2.EtebaseFetchOptions>.fromAddress(
      (invocation.arguments[1] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_invitation_manager_list_outgoing(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionInvitationManager>.fromAddress(
      (invocation.arguments[0] as int));
  final fetchOptions = _i5.Pointer<_i2.EtebaseFetchOptions>.fromAddress(
      (invocation.arguments[1] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_invitation_manager_accept(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionInvitationManager>.fromAddress(
      (invocation.arguments[0] as int));
  final invitation = _i5.Pointer<_i2.EtebaseSignedInvitation>.fromAddress(
      (invocation.arguments[1] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_invitation_manager_reject(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionInvitationManager>.fromAddress(
      (invocation.arguments[0] as int));
  final invitation = _i5.Pointer<_i2.EtebaseSignedInvitation>.fromAddress(
      (invocation.arguments[1] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_invitation_manager_fetch_user_profile(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionInvitationManager>.fromAddress(
      (invocation.arguments[0] as int));
  final username = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: alloc)
      .cast<_i5.Char>();
  throw UnimplementedError();
}

_i1.MethodResult _etebase_invitation_manager_invite(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 5,
      'Invocation must have exactly 5 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionInvitationManager>.fromAddress(
      (invocation.arguments[0] as int));
  final collection = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[1] as int));
  final username = (invocation.arguments[2] as String)
      .toNativeUtf8(allocator: alloc)
      .cast<_i5.Char>();
  final pubkey_size = (invocation.arguments[3] as _i6.Uint8List).length;
  final pubkey = alloc<_i5.Uint8>(pubkey_size);
  pubkey.asTypedList(pubkey_size).setAll(
        0,
        (invocation.arguments[3] as _i6.Uint8List),
      );
  final accessLevel =
      (invocation.arguments[4] as _i8.EtebaseCollectionAccessLevel).index;
  throw UnimplementedError();
}

_i1.MethodResult _etebase_invitation_manager_disinvite(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionInvitationManager>.fromAddress(
      (invocation.arguments[0] as int));
  final invitation = _i5.Pointer<_i2.EtebaseSignedInvitation>.fromAddress(
      (invocation.arguments[1] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_invitation_manager_get_pubkey(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionInvitationManager>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_invitation_manager_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollectionInvitationManager>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_clone(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_verify(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_set_meta(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final meta = _i5.Pointer<_i2.EtebaseItemMetadata>.fromAddress(
      (invocation.arguments[1] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_get_meta(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_set_meta_raw(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final meta_size = (invocation.arguments[1] as _i6.Uint8List).length;
  final meta = alloc<_i5.Uint8>(meta_size);
  meta.asTypedList(meta_size).setAll(
        0,
        (invocation.arguments[1] as _i6.Uint8List),
      );
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_get_meta_raw(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_set_content(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  final content_size = (invocation.arguments[1] as _i6.Uint8List).length;
  final content = alloc<_i5.Uint8>(content_size);
  content.asTypedList(content_size).setAll(
        0,
        (invocation.arguments[1] as _i6.Uint8List),
      );
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_get_content(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_delete(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_is_deleted(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_get_uid(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_get_etag(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_get_stoken(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_as_item(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_get_collection_type(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_get_access_level(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_collection_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseCollection>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_client_new(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final clientName = (invocation.arguments[0] as String)
      .toNativeUtf8(allocator: alloc)
      .cast<_i5.Char>();
  final serverUrl = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: alloc)
      .cast<_i5.Char>();
  throw UnimplementedError();
}

_i1.MethodResult _etebase_client_set_server_url(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseClient>.fromAddress(
      (invocation.arguments[0] as int));
  final serverUrl = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: alloc)
      .cast<_i5.Char>();
  throw UnimplementedError();
}

_i1.MethodResult _etebase_client_check_etebase_server(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final client = _i5.Pointer<_i2.EtebaseClient>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_client_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseClient>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_account_login(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  final client = _i5.Pointer<_i2.EtebaseClient>.fromAddress(
      (invocation.arguments[0] as int));
  final username = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: alloc)
      .cast<_i5.Char>();
  final password = (invocation.arguments[2] as String)
      .toNativeUtf8(allocator: alloc)
      .cast<_i5.Char>();
  throw UnimplementedError();
}

_i1.MethodResult _etebase_account_signup(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  final client = _i5.Pointer<_i2.EtebaseClient>.fromAddress(
      (invocation.arguments[0] as int));
  final user = _i5.Pointer<_i2.EtebaseUser>.fromAddress(
      (invocation.arguments[1] as int));
  final password = (invocation.arguments[2] as String)
      .toNativeUtf8(allocator: alloc)
      .cast<_i5.Char>();
  throw UnimplementedError();
}

_i1.MethodResult _etebase_account_fetch_token(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseAccount>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_account_fetch_dashboard_url(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseAccount>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_account_force_server_url(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseAccount>.fromAddress(
      (invocation.arguments[0] as int));
  final serverUrl = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: alloc)
      .cast<_i5.Char>();
  throw UnimplementedError();
}

_i1.MethodResult _etebase_account_change_password(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseAccount>.fromAddress(
      (invocation.arguments[0] as int));
  final password = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: alloc)
      .cast<_i5.Char>();
  throw UnimplementedError();
}

_i1.MethodResult _etebase_account_logout(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseAccount>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_account_get_collection_manager(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseAccount>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_account_get_invitation_manager(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseAccount>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _etebase_account_save(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 2,
      'Invocation must have exactly 2 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseAccount>.fromAddress(
      (invocation.arguments[0] as int));
  final encryptionKey_size = (invocation.arguments[1] as _i6.Uint8List).length;
  final encryptionKey = alloc<_i5.Uint8>(encryptionKey_size);
  encryptionKey.asTypedList(encryptionKey_size).setAll(
        0,
        (invocation.arguments[1] as _i6.Uint8List),
      );
  throw UnimplementedError();
}

_i1.MethodResult _etebase_account_restore(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 3,
      'Invocation must have exactly 3 arguments');
  final client = _i5.Pointer<_i2.EtebaseClient>.fromAddress(
      (invocation.arguments[0] as int));
  final accountDataStored = (invocation.arguments[1] as String)
      .toNativeUtf8(allocator: alloc)
      .cast<_i5.Char>();
  final encryptionKey_size = (invocation.arguments[2] as _i6.Uint8List).length;
  final encryptionKey = alloc<_i5.Uint8>(encryptionKey_size);
  encryptionKey.asTypedList(encryptionKey_size).setAll(
        0,
        (invocation.arguments[2] as _i6.Uint8List),
      );
  throw UnimplementedError();
}

_i1.MethodResult _etebase_account_destroy(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final this_ = _i5.Pointer<_i2.EtebaseAccount>.fromAddress(
      (invocation.arguments[0] as int));
  throw UnimplementedError();
}

_i1.MethodResult _ETEBASE_UTILS_PRETTY_FINGERPRINT_SIZE(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 0,
      'Invocation must have exactly 0 arguments');
  throw UnimplementedError();
}

_i1.MethodResult _etebase_utils_randombytes(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final size = (invocation.arguments[0] as int);
  throw UnimplementedError();
}

_i1.MethodResult _etebase_utils_pretty_fingerprint(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 1,
      'Invocation must have exactly 1 arguments');
  final content_size = (invocation.arguments[0] as _i6.Uint8List).length;
  final content = alloc<_i5.Uint8>(content_size);
  content.asTypedList(content_size).setAll(
        0,
        (invocation.arguments[0] as _i6.Uint8List),
      );
  throw UnimplementedError();
}

_i1.MethodResult _etebase_get_default_server_url(
  _i2.LibEtebaseFFI libEtebase,
  _i3.MethodInvocation invocation,
  _i5.Allocator alloc,
) {
  assert(invocation.arguments.length == 0,
      'Invocation must have exactly 0 arguments');
  throw UnimplementedError();
}
