import type { ItemMetadata } from "etebase";
import type { CollectionActionConfig, CollectionAction } from "../util/action";

type CreateItemAction = CollectionAction & {
  collectionType: string;
  meta: ItemMetadata;
  content: string;
};

export const createItemConfig: CollectionActionConfig<CreateItemAction> = {
  type: 'collection',
  name: 'createItem',
  callback: async ({ utils, etebase, collectionManager, collection, action: { collectionType, meta, content } }) => {
    const im = collectionManager.getItemManager(collection);
    const item = await im.create(meta, etebase.fromBase64(content));
    utils.assert(item.verify(), 'Unable to verify item');
    await im.batch([item]);
    return item.uid;
  }
};
