import type { ActionConfig, Action } from "../util/action";

type SignUpAction = Action & {
  username: string;
  email: string;
  password: string;
  serverUrl?: string;
};

export const signUpConfig: ActionConfig<SignUpAction> = {
  name: 'signUp',
  callback: async ({ etebase, utils, action: { username, email, password, serverUrl } }) => {
    const account = await etebase.Account.signup({ username, email }, password, serverUrl);
    utils.assert(account.authToken !== null, 'account has no authToken');
  }
};

