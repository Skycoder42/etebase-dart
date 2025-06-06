import type { SignedInActionConfig, SignedInAction } from "../util/action";

type AcceptInvitationAction = SignedInAction & {
  collection: string;
  fromPubKey: string;
  fromUsername: string;
  username: string;
  accept: boolean;
};

export const acceptInvitationConfig: SignedInActionConfig<AcceptInvitationAction> = {
  type: 'signedIn',
  name: 'acceptInvitation',
  callback: async ({ etebase, utils, account, action: { collection, fromPubKey, fromUsername, username, accept } }) => {
    const im = account.getInvitationManager();

    const invitations = await im.listIncoming();
    utils.assert(
      invitations.data.length === 1,
      `There should only be one invitation, but data has ${invitations.data.length}`,
    );
    utils.assert(
      invitations.done,
      "There should only be one invitation, but done is false",
    );

    const [invitation] = invitations.data;
    utils.assert(
      invitation.collection === collection,
      `Invitation collection does not match (Expected: ${collection}, Actual: ${invitation.collection})`,
    );
    const encodedFromPubkey = etebase.toBase64(invitation.fromPubkey);
    utils.assert(
      encodedFromPubkey === fromPubKey,
      `Invitation fromPubKey does not match (Expected: ${fromPubKey}, Actual: ${encodedFromPubkey})`,
    );
    utils.assert(
      invitation.fromUsername === fromUsername,
      `Invitation fromUsername does not match (Expected: ${fromUsername}, Actual: ${invitation.fromUsername})`,
    );
    utils.assert(
      invitation.username === username,
      `Invitation username does not match (Expected: ${username}, Actual: ${invitation.username})`,
    );

    if (accept) {
      await im.accept(invitation);
    } else {
      await im.reject(invitation);
    }
  }
};
