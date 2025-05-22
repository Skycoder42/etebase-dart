import type { ActionConfig, SignedInAction } from "../util/action";

type SignUpAction = SignedInAction & {
  email: string;
};

export const signUpConfig: ActionConfig<SignUpAction> = {
  name: 'signUp',
  callback: async ({ etebase, action: { username, email, password, serverUrl } }) => {
    const account = await etebase.Account.signup({ username, email }, password, serverUrl);
    console.assert(account.authToken, 'account has no authToken', account);
  }
};

