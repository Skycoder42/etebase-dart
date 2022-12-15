@TestOn('!windows')
library sharing_test;

import 'dart:typed_data';

// ignore: test_library_import
import 'package:etebase/etebase.dart';
import 'package:test/test.dart';

import 'util/library_loader.dart';
import 'util/matchers.dart';

void main() {
  const testCollectionType = 'etebase-dart.sharing_test';
  final userName1 = generateUsername('sharing-test-user-1');
  final userName2 = generateUsername('sharing-test-user-2');

  late final EtebaseCollectionManager collectionManager1;
  late final EtebaseCollectionInvitationManager invitationManager1;

  late final EtebaseCollectionManager collectionManager2;
  late final EtebaseCollectionInvitationManager invitationManager2;

  setUpAll(() async {
    await Etebase.ensureInitialized(loadLibEtebase);

    final client = await EtebaseClient.create('sharing-test', serverUri);
    addTearDown(client.dispose);

    final account1 = await EtebaseAccount.signup(
      client,
      EtebaseUser(
        username: userName1,
        email: 'sharing1@test.com',
      ),
      'password',
    );
    addTearDown(account1.dispose);

    collectionManager1 = await account1.getCollectionManager();
    addTearDown(collectionManager1.dispose);
    invitationManager1 = await account1.getInvitationManager();
    addTearDown(invitationManager1.dispose);

    final account2 = await EtebaseAccount.signup(
      client,
      EtebaseUser(
        username: userName2,
        email: 'sharing2@test.com',
      ),
      'password',
    );
    addTearDown(account2.dispose);

    collectionManager2 = await account2.getCollectionManager();
    addTearDown(collectionManager2.dispose);
    invitationManager2 = await account2.getInvitationManager();
    addTearDown(invitationManager2.dispose);
  });

  test('can obtain personal fingerprint and profiles', () async {
    final pubKey1 = await invitationManager1.getPubkey();
    final pubKey2 = await invitationManager2.getPubkey();

    expect(pubKey1, isNot(pubKey2));

    final prettyPubKey1 = await EtebaseUtils.prettyFingerprint(pubKey1);
    final prettyPubKey2 = await EtebaseUtils.prettyFingerprint(pubKey2);

    expect(prettyPubKey1, isNot(prettyPubKey2));

    final profile1 = await invitationManager2.fetchUserProfile(userName1);
    addTearDown(profile1.dispose);
    final profile2 = await invitationManager1.fetchUserProfile(userName2);
    addTearDown(profile2.dispose);

    expect(await profile1.getPubkey(), pubKey1);
    expect(await profile2.getPubkey(), pubKey2);
  });

  test('can invite others to a collection', () async {
    // create collection
    final collection = await collectionManager1.create(
      testCollectionType,
      const EtebaseItemMetadata(),
      Uint8List(0),
    );
    addTearDown(collection.dispose);
    await collectionManager1.upload(collection);

    // create invitation
    final profile2 = await invitationManager2.fetchUserProfile(userName2);
    addTearDown(profile2.dispose);
    await invitationManager1.invite(
      collection,
      userName2,
      await profile2.getPubkey(),
      EtebaseCollectionAccessLevel.readWrite,
    );

    // validate outgoing invitation
    final outResponse = await invitationManager1.listOutgoing();
    addTearDown(outResponse.dispose);
    expect(await outResponse.isDone(), isTrue);
    expect(await outResponse.getIterator(), isNotEmpty);

    final outInvitations = await outResponse.getData();
    expect(outInvitations, hasLength(1));
    final outInvitation = outInvitations[0];
    expect(
      await outInvitation.getAccessLevel(),
      EtebaseCollectionAccessLevel.readWrite,
    );
    expect(await outInvitation.getCollection(), await collection.getUid());
    expect(
      await outInvitation.getFromPubkey(),
      await invitationManager1.getPubkey(),
    );
    // TODO is currently broken, don't know why
    // expect(await outInvitation.getFromUsername(), userName1);
    expect(await outInvitation.getUid(), isNotEmpty);
    expect(await outInvitation.getUsername(), userName2);
    final outInvitationClone = await outInvitation.clone();
    addTearDown(outInvitationClone.dispose);
    expect(await outInvitationClone.getUid(), await outInvitation.getUid());

    // validate incoming invitation
    final inResponse = await invitationManager2.listIncoming();
    addTearDown(inResponse.dispose);
    expect(await inResponse.isDone(), isTrue);
    expect(await inResponse.getIterator(), isNotEmpty);

    final inInvitations = await inResponse.getData();
    expect(inInvitations, hasLength(1));
    final inInvitation = inInvitations[0];
    expect(
      await inInvitation.getAccessLevel(),
      EtebaseCollectionAccessLevel.readWrite,
    );
    expect(await inInvitation.getCollection(), await collection.getUid());
    expect(
      await inInvitation.getFromPubkey(),
      await invitationManager1.getPubkey(),
    );
    // TODO is currently broken, don't know why
    // expect(await inInvitation.getFromUsername(), userName1);
    expect(await inInvitation.getUid(), await outInvitation.getUid());
    expect(await inInvitation.getUsername(), userName2);
    final inInvitationClone = await inInvitation.clone();
    addTearDown(inInvitationClone.dispose);
    expect(await inInvitationClone.getUid(), await inInvitation.getUid());

    // accept invitation
    await invitationManager2.accept(inInvitation);

    final sharedCollection =
        await collectionManager2.fetch(await collection.getUid());
    addTearDown(sharedCollection.dispose);
    expect(
      await sharedCollection.getAccessLevel(),
      EtebaseCollectionAccessLevel.readWrite,
    );

    final outResponse2 = await invitationManager1.listOutgoing();
    addTearDown(outResponse2.dispose);
    expect(await outResponse2.getData(), isEmpty);
    final inResponse2 = await invitationManager2.listIncoming();
    addTearDown(inResponse2.dispose);
    expect(await inResponse2.getData(), isEmpty);
  });

  test('invitations can be canceled and rejected', () async {
    // create collection
    final collection = await collectionManager1.create(
      testCollectionType,
      const EtebaseItemMetadata(),
      Uint8List(0),
    );
    addTearDown(collection.dispose);
    await collectionManager1.upload(collection);

    final profile2 = await invitationManager2.fetchUserProfile(userName2);
    addTearDown(profile2.dispose);

    // create invitation
    await invitationManager1.invite(
      collection,
      userName2,
      await profile2.getPubkey(),
      EtebaseCollectionAccessLevel.readWrite,
    );

    final outResponse1 = await invitationManager1.listOutgoing();
    addTearDown(outResponse1.dispose);
    expect(await outResponse1.getData(), hasLength(1));
    final inResponse1 = await invitationManager2.listIncoming();
    addTearDown(inResponse1.dispose);
    expect(await inResponse1.getData(), hasLength(1));

    // cancel invitation
    await invitationManager1.disinvite((await outResponse1.getData()).single);

    final outResponse2 = await invitationManager1.listOutgoing();
    addTearDown(outResponse2.dispose);
    expect(await outResponse2.getData(), isEmpty);
    final inResponse2 = await invitationManager2.listIncoming();
    addTearDown(inResponse2.dispose);
    expect(await inResponse2.getData(), isEmpty);

    // create another invitation
    await invitationManager1.invite(
      collection,
      userName2,
      await profile2.getPubkey(),
      EtebaseCollectionAccessLevel.readWrite,
    );

    final outResponse3 = await invitationManager1.listOutgoing();
    addTearDown(outResponse3.dispose);
    expect(await outResponse3.getData(), hasLength(1));
    final inResponse3 = await invitationManager2.listIncoming();
    addTearDown(inResponse3.dispose);
    expect(await inResponse3.getData(), hasLength(1));

    await expectLater(
      () async => collectionManager2.fetch(await collection.getUid()),
      throwsEtebaseException(),
    );

    // reject the invitation
    await invitationManager2.reject((await inResponse3.getData()).single);

    final outResponse4 = await invitationManager1.listOutgoing();
    addTearDown(outResponse4.dispose);
    expect(await outResponse4.getData(), isEmpty);
    final inResponse4 = await invitationManager2.listIncoming();
    addTearDown(inResponse4.dispose);
    expect(await inResponse4.getData(), isEmpty);

    // validate has no access
    // TODO does ACCEPT! FIX BUG!
    // await expectLater(
    //   () async => collectionManager2.fetch(await collection.getUid()),
    //   throwsEtebaseException(),
    // );
  });

  test('can leave shared collection', () async {
    // create and share collection
    final collection = await collectionManager1.create(
      testCollectionType,
      const EtebaseItemMetadata(),
      Uint8List(0),
    );
    addTearDown(collection.dispose);
    await collectionManager1.upload(collection);
    final profile2 = await invitationManager2.fetchUserProfile(userName2);
    addTearDown(profile2.dispose);
    await invitationManager1.invite(
      collection,
      userName2,
      await profile2.getPubkey(),
      EtebaseCollectionAccessLevel.readOnly,
    );
    final inResponse = await invitationManager2.listIncoming();
    addTearDown(inResponse.dispose);
    await invitationManager2.accept((await inResponse.getData()).single);

    // leave collection
    final sharedCollection =
        await collectionManager2.fetch(await collection.getUid());
    addTearDown(sharedCollection.dispose);
    expect(
      await sharedCollection.getAccessLevel(),
      EtebaseCollectionAccessLevel.readOnly,
    );

    final memberManager =
        await collectionManager2.getMemberManager(sharedCollection);
    addTearDown(memberManager.dispose);
    await memberManager.leave();

    // validate has no access
    await expectLater(
      () async => collectionManager2.fetch(await collection.getUid()),
      throwsEtebaseException(),
    );
  });

  test('can manage members of collection', () async {
    // create and share collection
    final collection = await collectionManager1.create(
      testCollectionType,
      const EtebaseItemMetadata(),
      Uint8List(0),
    );
    addTearDown(collection.dispose);
    await collectionManager1.upload(collection);
    final profile2 = await invitationManager2.fetchUserProfile(userName2);
    addTearDown(profile2.dispose);
    await invitationManager1.invite(
      collection,
      userName2,
      await profile2.getPubkey(),
      EtebaseCollectionAccessLevel.readOnly,
    );
    final inResponse = await invitationManager2.listIncoming();
    addTearDown(inResponse.dispose);
    await invitationManager2.accept((await inResponse.getData()).single);

    final sharedCollection1 =
        await collectionManager2.fetch(await collection.getUid());
    addTearDown(sharedCollection1.dispose);
    expect(
      await sharedCollection1.getAccessLevel(),
      EtebaseCollectionAccessLevel.readOnly,
    );

    final memberManager = await collectionManager1.getMemberManager(collection);
    addTearDown(memberManager.dispose);

    // list members
    final membersResponse = await memberManager.list();
    addTearDown(membersResponse.dispose);
    expect(await membersResponse.isDone(), isTrue);
    expect(await membersResponse.getIterator(), isNotEmpty);
    final members = await membersResponse.getData();

    expect(members, hasLength(2));
    final member1 = members[0];
    expect(await member1.getUsername(), userName1);
    expect(await member1.getAccessLevel(), EtebaseCollectionAccessLevel.admin);
    final member2 = members[1];
    expect(await member2.getUsername(), userName2);
    expect(
      await member2.getAccessLevel(),
      EtebaseCollectionAccessLevel.readOnly,
    );
    final clonedMember = await member1.clone();
    addTearDown(clonedMember.dispose);

    // edit member access
    await memberManager.modifyAccessLevel(
      userName2,
      EtebaseCollectionAccessLevel.readWrite,
    );

    final sharedCollection2 =
        await collectionManager2.fetch(await collection.getUid());
    addTearDown(sharedCollection2.dispose);
    expect(
      await sharedCollection2.getAccessLevel(),
      EtebaseCollectionAccessLevel.readWrite,
    );

    // remove member
    await memberManager.remove(userName2);
    final removedMembersResponse = await memberManager.list();
    addTearDown(removedMembersResponse.dispose);
    expect(await removedMembersResponse.getData(), hasLength(1));

    // TODO currently broken
    // final collectionsResponse =
    //     await collectionManager2.list(testCollectionType);
    // addTearDown(collectionsResponse.dispose);
    // final removedCollections =
    //     await collectionsResponse.getRemovedMemberships();
    // expect(removedCollections, hasLength(1));

    // final removedCollection = removedCollections[0];
    // expect(await removedCollection.getUid(), await collection.getUid());

    await expectLater(
      () async => collectionManager2.fetch(await collection.getUid()),
      throwsEtebaseException(),
    );
  });
}
