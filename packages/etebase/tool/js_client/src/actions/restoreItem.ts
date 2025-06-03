import type { ItemMetadata } from "etebase";
import type { CollectionActionConfig, CollectionAction } from "../util/action";

type RestoreItemAction = CollectionAction & {
  data: string;
  meta?: ItemMetadata;
  content?: string;
  noContent: boolean;
  isDeleted?: boolean;
};

export const restoreItemConfig: CollectionActionConfig<RestoreItemAction> = {
  type: 'collection',
  name: 'restoreItem',
  callback: async ({ utils, etebase, collectionManager, collection, action: { data, meta, content, noContent, isDeleted } }) => {
    const im = collectionManager.getItemManager(collection);
    const item = im.cacheLoad(etebase.fromBase64(data));
    utils.assert(item.verify(), 'Unable to verify item');

    if (typeof meta !== "undefined") {
      const itemMeta = item.getMeta();
      utils.assert(
        JSON.stringify(itemMeta) === JSON.stringify(meta),
        `Item metadata does not match (Expected: ${JSON.stringify(meta)}, Actual: ${JSON.stringify(itemMeta)})`,
      );
    }

    if (noContent) {
      utils.assert(item.isMissingContent, "Item should be missing content, but is not");
      try {
        const itemContent = await item.getContent();
        utils.assert(false, `Expected getContent to throw, but it returned ${etebase.toBase64(itemContent)}`);
      } catch (e: any) {
        utils.assert(e instanceof etebase.MissingContentError, `Expected content to throw MissingContentError, but did throw ${e}`);
      }
    } else if (typeof content !== "undefined") {
      const itemContent = await item.getContent();
      const encodedContent = etebase.toBase64(itemContent);
      utils.assert(
        encodedContent === content,
        `Item content does not match (Expected: ${content}, Actual: ${encodedContent})`,
      );
    }

    if (typeof isDeleted !== "undefined") {
      utils.assert(
        item.isDeleted == isDeleted,
        `Item deletion state does not match (Expected: ${isDeleted}, Actual: ${item.isDeleted})`,
      );
    }
  }
};
