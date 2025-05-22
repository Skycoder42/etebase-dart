import type { ActionConfig, Action } from "../util/action";

type RestoreAccountAction = Action & {
  data: string;
  encryptionKey: string;
};

export const restoreAccountConfig: ActionConfig<RestoreAccountAction> = {
  name: 'restoreAccount',
  callback: async ({ etebase, action: { data, encryptionKey } }) => {
    const account = await etebase.Account.restore(data, etebase.fromBase64(encryptionKey));
    console.assert(account.authToken, 'account has no authToken', account);
  }
};


