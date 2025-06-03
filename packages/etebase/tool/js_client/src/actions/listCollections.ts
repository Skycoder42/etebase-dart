import type { SignedInActionConfig, SignedInAction } from "../util/action";

type ListCollectionsAction = SignedInAction & {
  types: string[];
};

export const listCollectionsConfig: SignedInActionConfig<ListCollectionsAction> = {
  type: 'signedIn',
  name: 'listCollections',
  callback: async ({ etebase, account, action: { types } }) => {
    const cm = account.getCollectionManager();
    const collectionUids: string[] = [];
    let stoken: string | null = null;
    let done = false;
    while (!done) {
      const response = await cm.list(types, { stoken });
      for (const col of response.data) {
        collectionUids.push(col.uid);
      }
      stoken = response.stoken;
      done = response.done;
    }
    return collectionUids;
  }
};
