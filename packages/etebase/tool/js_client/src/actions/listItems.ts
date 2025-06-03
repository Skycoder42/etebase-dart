import type { CollectionAction, CollectionActionConfig } from "../util/action";

type ListItemsAction = CollectionAction;

export const listItemsConfig: CollectionActionConfig<ListItemsAction> = {
  type: 'collection',
  name: 'listItems',
  callback: async ({ collectionManager, collection }) => {
    const im = collectionManager.getItemManager(collection);
    const itemUids: string[] = [];
    let stoken: string | null = null;
    let done = false;
    while (!done) {
      const response = await im.list({ stoken });
      for (const item of response.data) {
        itemUids.push(item.uid);
      }
      stoken = response.stoken;
      done = response.done;
    }
    return itemUids;
  }
};
