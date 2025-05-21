import type { ActionCallback, SignedInAction } from "../util/action";

export const signInActionName = "signIn";

export type SignInAction = SignedInAction;

export const signInAction: ActionCallback<SignInAction> = async ({ etebase, action: { username, password, serverUrl } }) => {
  const account = await etebase.Account.login(username, password, serverUrl);
  console.assert(account.authToken, 'account has not authToken', account);
};
