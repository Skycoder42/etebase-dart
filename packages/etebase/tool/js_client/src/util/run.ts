import type { Etebase, Action, SignedInAction, AnyActionConfig, TestUtils, CollectionAction } from './action';

export const run = async (etebase: Etebase, utils: TestUtils, action: Action, config: AnyActionConfig): Promise<any> => {
  try {
    switch (config.type) {
      case "collection":
        {
          var collectionAction = action as CollectionAction;
          const account = await etebase.Account.restore(collectionAction.savedAccountData);
          const collectionManager = account.getCollectionManager();
          const collection = await collectionManager.fetch(collectionAction.colUid);
          return await config.callback({
            etebase,
            utils,
            account,
            collectionManager,
            collection,
            action
          });
        }
      case "signedIn":
        {
          var signedInAction = action as SignedInAction;
          const account = await etebase.Account.restore(signedInAction.savedAccountData);
          return await config.callback({ etebase, utils, account, action });
        }
      default:
        return await config.callback({ etebase, utils, action });
    }
  } catch (e: any) {
    if (e instanceof Error) {
      throw `${e.name}: ${e.message}\n${e.stack}`;
    } else {
      throw e;
    }
  }
}
