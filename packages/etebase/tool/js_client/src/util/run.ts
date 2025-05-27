import type { Etebase, Action, SignedInAction, AnyActionConfig, TestUtils } from './action';

export const run = async (etebase: Etebase, utils: TestUtils, action: Action, config: AnyActionConfig): Promise<any> => {
  if (config.signedIn) {
    var signedInAction = action as SignedInAction;
    const account = await etebase.Account.login(
      signedInAction.username,
      signedInAction.password,
      signedInAction.serverUrl
    );
    return await config.callback({ etebase, utils, account, action });
  } else {
    return await config.callback({ etebase, utils, action });
  }
}
