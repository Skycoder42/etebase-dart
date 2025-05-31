import type { SignedInActionConfig, SignedInAction } from "../util/action";

type SaveCollectionAction = SignedInAction & {
  uid: string;
  preserveContent: boolean
};

export const saveCollectionConfig: SignedInActionConfig<SaveCollectionAction> = {
  signedIn: true,
  name: 'saveCollection',
  callback: async ({ etebase, utils, account, action: { uid, preserveContent } }) => {
    const cm = account.getCollectionManager();
    const col = await cm.fetch(uid);
    utils.assert(col.verify(), 'Unable to verify collection');

    return etebase.toBase64(cm.cacheSave(col, { saveContent: preserveContent }));
  }
};
