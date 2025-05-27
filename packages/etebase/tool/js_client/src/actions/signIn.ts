import type { ActionConfig, SignedInAction } from "../util/action";

type SignInAction = SignedInAction;

export const signInConfig: ActionConfig<SignInAction> = {
  name: 'signIn',
  callback: async ({ etebase, utils, action: { username, password, serverUrl } }) => {
    const account = await etebase.Account.login(username, password, serverUrl);
    utils.assert(account.authToken !== null, 'account has no authToken');
  }
};
