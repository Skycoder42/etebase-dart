@TestOn('!windows')
library;

import 'dart:typed_data';

// ignore: no_self_package_imports
import 'package:etebase/etebase.dart';
import 'package:test/test.dart';

import 'util/js_client_wrapper.dart';
import 'util/library_loader.dart';

void main() {
  const testCollectionType = 'etebase-dart.sharing_test';
  final userName1 = generateUsername('sharing-test-user-1');
  final userName2 = generateUsername('sharing-test-user-2');

  late final EtebaseClient client;

  late final EtebaseCollectionManager collectionManager1;
  late final EtebaseCollectionInvitationManager invitationManager1;
  final jsClientWrapper1 = JsClientWrapper();

  late final EtebaseCollectionManager collectionManager2;
  late final EtebaseCollectionInvitationManager invitationManager2;
  final jsClientWrapper2 = JsClientWrapper();

  setUpAll(() async {
    client = await createClient();
    addTearDown(client.dispose);

    final account1 = await EtebaseAccount.signup(
      client,
      EtebaseUser(username: userName1, email: 'sharing1@test.com'),
      'password',
    );
    addTearDown(account1.dispose);

    collectionManager1 = account1.collectionManager;
    invitationManager1 = account1.invitationManager;
    jsClientWrapper1.configureAccount(account1);

    final account2 = await EtebaseAccount.signup(
      client,
      EtebaseUser(username: userName2, email: 'sharing2@test.com'),
      'password',
    );
    addTearDown(account2.dispose);

    collectionManager2 = account2.collectionManager;
    invitationManager2 = account2.invitationManager;
    jsClientWrapper2.configureAccount(account2);
  });

  test('can obtain personal fingerprint and profiles', () async {
    final pubKey1 = invitationManager1.pubkey;
    final pubKey2 = invitationManager2.pubkey;

    expect(pubKey1, isNot(pubKey2));

    final prettyPubKey1 = EtebaseUtils.prettyFingerprint(client, pubKey1);
    final prettyPubKey2 = EtebaseUtils.prettyFingerprint(client, pubKey2);

    expect(prettyPubKey1, isNot(prettyPubKey2));

    final profile1 = await invitationManager2.fetchUserProfile(userName1);
    final profile2 = await invitationManager1.fetchUserProfile(userName2);

    expect(profile1.pubkey, pubKey1);
    expect(profile2.pubkey, pubKey2);

    // compare with JS keys
    await jsClientWrapper1.executeSignedIn<void>(
      Action.validatePubkey(pubKey1, prettyPubKey1),
    );
    await jsClientWrapper2.executeSignedIn<void>(
      Action.validatePubkey(pubKey2, prettyPubKey2),
    );
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
    await invitationManager1.invite(
      collection,
      userName2,
      profile2.pubkey,
      EtebaseCollectionAccessLevel.readWrite,
    );

    // validate outgoing invitation
    final outResponse = await invitationManager1.listOutgoing();
    expect(outResponse.isDone, isTrue);
    expect(outResponse.iterator, isNotEmpty);

    final outInvitations = outResponse.data;
    expect(outInvitations, hasLength(1));
    final outInvitation = outInvitations[0];
    expect(outInvitation.accessLevel, EtebaseCollectionAccessLevel.readWrite);
    expect(outInvitation.collection, collection.uid);
    expect(outInvitation.fromPubKey, invitationManager1.pubkey);
    expect(outInvitation.fromUsername, userName1);
    expect(outInvitation.uid, isNotEmpty);
    expect(outInvitation.username, userName2);

    // validate incoming invitation
    final inResponse = await invitationManager2.listIncoming();
    expect(inResponse.isDone, isTrue);
    expect(inResponse.iterator, isNotEmpty);

    final inInvitations = inResponse.data;
    expect(inInvitations, hasLength(1));
    final inInvitation = inInvitations[0];
    expect(inInvitation.accessLevel, EtebaseCollectionAccessLevel.readWrite);
    expect(inInvitation.collection, collection.uid);
    expect(inInvitation.fromPubKey, invitationManager1.pubkey);
    expect(inInvitation.fromUsername, userName1);
    expect(inInvitation.uid, outInvitation.uid);
    expect(inInvitation.username, userName2);

    // accept invitation
    await invitationManager2.accept(inInvitation);

    final sharedCollection = await collectionManager2.fetch(collection.uid);
    addTearDown(sharedCollection.dispose);
    expect(
      sharedCollection.accessLevel,
      EtebaseCollectionAccessLevel.readWrite,
    );

    final outResponse2 = await invitationManager1.listOutgoing();
    expect(outResponse2.data, isEmpty);
    final inResponse2 = await invitationManager2.listIncoming();
    expect(inResponse2.data, isEmpty);
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

    // create invitation
    await invitationManager1.invite(
      collection,
      userName2,
      profile2.pubkey,
      EtebaseCollectionAccessLevel.readWrite,
    );

    final outResponse1 = await invitationManager1.listOutgoing();
    expect(outResponse1.data, hasLength(1));
    final inResponse1 = await invitationManager2.listIncoming();
    expect(inResponse1.data, hasLength(1));

    // cancel invitation
    await invitationManager1.disinvite(outResponse1.data.single);

    final outResponse2 = await invitationManager1.listOutgoing();
    expect(outResponse2.data, isEmpty);
    final inResponse2 = await invitationManager2.listIncoming();
    expect(inResponse2.data, isEmpty);

    // create another invitation
    await invitationManager1.invite(
      collection,
      userName2,
      profile2.pubkey,
      EtebaseCollectionAccessLevel.readWrite,
    );

    final outResponse3 = await invitationManager1.listOutgoing();
    expect(outResponse3.data, hasLength(1));
    final inResponse3 = await invitationManager2.listIncoming();
    expect(inResponse3.data, hasLength(1));

    await expectLater(
      () => collectionManager2.fetch(collection.uid),
      throwsA(isA<NotFound>()),
    );

    // reject the invitation
    await invitationManager2.reject(inResponse3.data.single);

    final outResponse4 = await invitationManager1.listOutgoing();
    expect(outResponse4.data, isEmpty);
    final inResponse4 = await invitationManager2.listIncoming();
    expect(inResponse4.data, isEmpty);

    // validate has no access
    await expectLater(
      () => collectionManager2.fetch(collection.uid),
      throwsA(isA<NotFound>()),
    );
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
    await invitationManager1.invite(
      collection,
      userName2,
      profile2.pubkey,
      EtebaseCollectionAccessLevel.readOnly,
    );
    final inResponse = await invitationManager2.listIncoming();
    await invitationManager2.accept(inResponse.data.single);

    // leave collection
    final sharedCollection = await collectionManager2.fetch(collection.uid);
    addTearDown(sharedCollection.dispose);
    expect(sharedCollection.accessLevel, EtebaseCollectionAccessLevel.readOnly);

    final memberManager = collectionManager2.getMemberManager(sharedCollection);
    await memberManager.leave();

    // validate has no access
    await expectLater(
      () => collectionManager2.fetch(collection.uid),
      throwsA(isA<NotFound>()),
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
    await invitationManager1.invite(
      collection,
      userName2,
      profile2.pubkey,
      EtebaseCollectionAccessLevel.readOnly,
    );
    final inResponse = await invitationManager2.listIncoming();
    await invitationManager2.accept(inResponse.data.single);

    final sharedCollection1 = await collectionManager2.fetch(collection.uid);
    addTearDown(sharedCollection1.dispose);
    expect(
      sharedCollection1.accessLevel,
      EtebaseCollectionAccessLevel.readOnly,
    );

    final memberManager = collectionManager1.getMemberManager(collection);

    // list members
    final membersResponse = await memberManager.list();
    expect(membersResponse.isDone, isTrue);
    expect(membersResponse.iterator, isNotEmpty);
    final members = membersResponse.data;

    expect(members, hasLength(2));
    final member1 = members[0];
    expect(member1.username, userName1);
    expect(member1.accessLevel, EtebaseCollectionAccessLevel.admin);
    final member2 = members[1];
    expect(member2.username, userName2);
    expect(member2.accessLevel, EtebaseCollectionAccessLevel.readOnly);

    // edit member access
    await memberManager.modifyAccessLevel(
      userName2,
      EtebaseCollectionAccessLevel.readWrite,
    );

    final sharedCollection2 = await collectionManager2.fetch(collection.uid);
    addTearDown(sharedCollection2.dispose);
    expect(
      sharedCollection2.accessLevel,
      EtebaseCollectionAccessLevel.readWrite,
    );

    // remove member
    await memberManager.remove(userName2);
    final removedMembersResponse = await memberManager.list();
    expect(removedMembersResponse.data, hasLength(1));

    final collectionsResponse = await collectionManager2.list(
      testCollectionType,
      EtebaseFetchOptions(stoken: sharedCollection2.stoken),
    );
    final removedCollections = collectionsResponse.removedMemberships;
    expect(removedCollections, allOf(isNotNull, hasLength(1)));

    final removedCollection = removedCollections![0];
    expect(removedCollection.uid, collection.uid);

    await expectLater(
      () => collectionManager2.fetch(collection.uid),
      throwsA(isA<NotFound>()),
    );
  });

  test('can share others across clients', () async {
    const testCrossType = 'etebase-dart.sharing_test.cross';
    // create collection
    final dartCollection = await collectionManager1.create(
      testCrossType,
      const EtebaseItemMetadata(name: 'cross-dart'),
      Uint8List.fromList([4, 2, 2, 4]),
    );
    addTearDown(dartCollection.dispose);
    await collectionManager1.upload(dartCollection);

    // create invitation
    final profile2 = await invitationManager2.fetchUserProfile(userName2);
    await invitationManager1.invite(
      dartCollection,
      userName2,
      profile2.pubkey,
      EtebaseCollectionAccessLevel.readOnly,
    );

    // validate and accept incoming invitation in JS
    await jsClientWrapper2.executeSignedIn<void>(
      Action.acceptInvitation(
        collection: dartCollection.uid,
        fromPubKey: invitationManager1.pubkey,
        fromUsername: userName1,
        username: userName2,
      ),
    );
    await jsClientWrapper2.executeSignedIn<void>(
      Action.validateCollection(
        dartCollection.uid,
        meta: const EtebaseItemMetadata(name: 'cross-dart'),
        content: Uint8List.fromList([4, 2, 2, 4]),
      ),
    );

    // invite from JS
    final jsColId = await jsClientWrapper2.executeSignedIn<String>(
      Action.createCollection(
        testCrossType,
        const EtebaseItemMetadata(name: 'cross-js'),
        Uint8List.fromList([1, 3, 3, 7]),
      ),
    );
    await jsClientWrapper2.executeSignedIn<void>(
      Action.invite(
        colUid: jsColId,
        pubKey: invitationManager1.pubkey,
        username: userName1,
        accessLevel: EtebaseCollectionAccessLevel.admin,
      ),
    );

    // validate incoming invitation
    final jsInvResponse = await invitationManager1.listIncoming();
    expect(jsInvResponse.isDone, isTrue);
    expect(jsInvResponse.iterator, isNotEmpty);
    expect(jsInvResponse.data, hasLength(1));

    final [jsInvitation] = jsInvResponse.data;
    expect(jsInvitation.accessLevel, EtebaseCollectionAccessLevel.admin);
    expect(jsInvitation.collection, jsColId);
    expect(jsInvitation.fromPubKey, invitationManager2.pubkey);
    expect(jsInvitation.fromUsername, userName2);
    expect(jsInvitation.username, userName1);

    await invitationManager1.accept(jsInvitation);

    final jsCollection = await collectionManager1.fetch(jsColId);
    addTearDown(jsCollection.dispose);
    expect(
      await jsCollection.getMeta(),
      const EtebaseItemMetadata(name: 'cross-js'),
    );
    expect(await jsCollection.getContent(), Uint8List.fromList([1, 3, 3, 7]));
    expect(jsCollection.accessLevel, EtebaseCollectionAccessLevel.admin);

    // remove original owner
    final memberManager = collectionManager1.getMemberManager(jsCollection);
    await memberManager.remove(userName2);

    final jsCols = await jsClientWrapper2.executeSignedIn<List<String>>(
      const Action.listCollections([testCrossType]),
    );
    expect(jsCols, hasLength(1));
    expect(jsCols, contains(dartCollection.uid));
  });
}
