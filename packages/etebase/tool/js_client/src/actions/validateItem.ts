import type { ItemMetadata } from "etebase";
import type { CollectionActionConfig, CollectionAction } from "../util/action";

type ValidateItemAction = CollectionAction & {
  uid: string;
  meta?: ItemMetadata;
  content?: string;
  isDeleted?: boolean;
};

export const validateItemConfig: CollectionActionConfig<ValidateItemAction> = {
  type: 'collection',
  name: 'validateItem',
  callback: async ({ etebase, utils, collectionManager, collection, action: { uid, meta, content, isDeleted } }) => {
    const im = collectionManager.getItemManager(collection);
    const item = await im.fetch(uid);
    utils.assert(item.verify(), 'Unable to verify collection');

    if (typeof meta === "object" && meta !== null) {
      const colMeta = item.getMeta();
      utils.assert(
        JSON.stringify(colMeta) === JSON.stringify(meta),
        `Item metadata does not match (Expected: ${JSON.stringify(meta)}, Actual: ${JSON.stringify(colMeta)})`,
      );
    }

    if (typeof content == "string") {
      const colContent = await item.getContent();
      const encodedContent = etebase.toBase64(colContent);
      utils.assert(
        encodedContent === content,
        `Item content does not match (Expected: ${content}, Actual: ${encodedContent})`,
      );
    }

    if (typeof isDeleted === "boolean") {
      utils.assert(
        item.isDeleted == isDeleted,
        `Item deletion state does not match (Expected: ${isDeleted}, Actual: ${item.isDeleted})`,
      );
    }
  }
};
