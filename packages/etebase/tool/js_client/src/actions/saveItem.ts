import type { CollectionActionConfig, CollectionAction } from "../util/action";

type SaveItemAction = CollectionAction & {
  uid: string;
  preserveContent: boolean
};

export const saveItemConfig: CollectionActionConfig<SaveItemAction> = {
  type: 'collection',
  name: 'saveItem',
  callback: async ({ etebase, utils, collectionManager, collection, action: { uid, preserveContent } }) => {
    const im = collectionManager.getItemManager(collection);
    const item = await im.fetch(uid);
    utils.assert(item.verify(), 'Unable to verify item');

    return etebase.toBase64(im.cacheSave(item, { saveContent: preserveContent }));
  }
};
