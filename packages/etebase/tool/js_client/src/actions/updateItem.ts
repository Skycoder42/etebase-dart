import type { ItemMetadata } from "etebase";
import type { CollectionActionConfig, CollectionAction } from "../util/action";

type UpdateItemAction = CollectionAction & {
  uid: string;
  meta?: ItemMetadata;
  content?: string;
  delete: boolean;
  preserveContent: boolean;
};

export const updateItemConfig: CollectionActionConfig<UpdateItemAction> = {
  type: 'collection',
  name: 'updateItem',
  callback: async ({ utils, etebase, collectionManager, collection, action: { uid, meta, content, delete: del, preserveContent } }) => {
    const im = collectionManager.getItemManager(collection);
    const item = await im.fetch(uid);
    utils.assert(item.verify(), 'Unable to verify item');

    if (meta) {
      item.setMeta(meta);
    }

    if (content) {
      item.setContent(etebase.fromBase64(content));
    }

    if (del) {
      item.delete(preserveContent);
    }

    await im.transaction([item]);

    utils.assert(item.verify(), 'Unable to verify item');
  }
};
