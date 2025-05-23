import type { Etebase, Action, SignedInAction, AnyActionConfig } from './action';

export const run = async (etebase: Etebase, action: Action, config: AnyActionConfig): Promise<any> => {
  if (config.signedIn) {
    var signedInAction = action as SignedInAction;
    const account = await etebase.Account.login(
      signedInAction.username,
      signedInAction.password,
      signedInAction.serverUrl
    );
    return await config.callback({ etebase, account, action });
  } else {
    return await config.callback({ etebase, action });
  }
}
