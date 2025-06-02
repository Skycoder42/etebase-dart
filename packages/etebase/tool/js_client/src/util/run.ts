import type { Etebase, Action, SignedInAction, AnyActionConfig, TestUtils } from './action';

export const run = async (etebase: Etebase, utils: TestUtils, action: Action, config: AnyActionConfig): Promise<any> => {
  try {
    if (config.signedIn) {
      var signedInAction = action as SignedInAction;
      const account = await etebase.Account.restore(signedInAction.savedAccountData);
      return await config.callback({ etebase, utils, account, action });
    } else {
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
