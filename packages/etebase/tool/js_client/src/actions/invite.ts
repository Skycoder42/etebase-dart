import type { CollectionAccessLevel } from "etebase";
import type { SignedInActionConfig, SignedInAction } from "../util/action";

type InviteAction = SignedInAction & {
  colUid: string;
  username: string;
  pubKey: string;
  accessLevel: CollectionAccessLevel;
};

export const inviteConfig: SignedInActionConfig<InviteAction> = {
  type: 'signedIn',
  name: 'invite',
  callback: async ({ etebase, utils, account, action: { colUid, username, pubKey, accessLevel } }) => {
    const cm = account.getCollectionManager();
    const im = account.getInvitationManager();

    const col = await cm.fetch(colUid);
    utils.assert(col.verify(), 'Unable to verify collection');

    await im.invite(col, username, etebase.fromBase64(pubKey), accessLevel);
  }
};
