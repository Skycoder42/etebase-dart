import type { ItemMetadata } from "etebase";
import type { SignedInActionConfig, SignedInAction } from "../util/action";

type CreateCollectionAction = SignedInAction & {
  collectionType: string;
  meta: ItemMetadata;
  content: string;
};

export const createCollectionConfig: SignedInActionConfig<CreateCollectionAction> = {
  signedIn: true,
  name: 'createCollection',
  callback: async ({ utils, account, action: { collectionType, meta, content } }) => {
    const cm = account.getCollectionManager();
    const col = await cm.create(collectionType, meta, content);
    utils.assert(col.verify(), 'Unable to verify collection');
    await cm.upload(col);
    return col.uid;
  }
};
