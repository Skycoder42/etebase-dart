import type { ItemMetadata } from "etebase";
import type { SignedInActionConfig, SignedInAction } from "../util/action";

type UpdateCollectionAction = SignedInAction & {
  uid: string;
  meta?: ItemMetadata;
  content?: string;
  delete: boolean;
  preserveContent: boolean;
};

export const updateCollectionConfig: SignedInActionConfig<UpdateCollectionAction> = {
  signedIn: true,
  name: 'updateCollection',
  callback: async ({ utils, etebase, account, action: { uid, meta, content, delete: del, preserveContent } }) => {
    const cm = account.getCollectionManager();
    const col = await cm.fetch(uid);
    utils.assert(col.verify(), 'Unable to verify collection');

    if (meta) {
      col.setMeta(meta);
    }

    if (content) {
      col.setContent(etebase.fromBase64(content));
    }

    if (del) {
      col.delete(preserveContent);
    }

    await cm.transaction(col);

    utils.assert(col.verify(), 'Unable to verify collection');
  }
};
