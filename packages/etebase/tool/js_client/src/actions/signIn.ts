import type { ActionConfig, SignedInAction } from "../util/action";

type SignInAction = SignedInAction;

export const signInConfig: ActionConfig<SignInAction> = {
  name: 'signIn',
  callback: async ({ etebase, action: { username, password, serverUrl } }) => {
    const account = await etebase.Account.login(username, password, serverUrl);
    console.assert(account.authToken, 'account has no authToken', account);
  }
};
