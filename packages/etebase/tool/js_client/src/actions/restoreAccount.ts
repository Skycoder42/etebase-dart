import type { ActionConfig, Action } from "../util/action";

type RestoreAccountAction = Action & {
  data: string;
  encryptionKey: string;
};

export const restoreAccountConfig: ActionConfig<RestoreAccountAction> = {
  name: 'restoreAccount',
  callback: async ({ etebase, utils, action: { data, encryptionKey } }) => {
    const account = await etebase.Account.restore(data, etebase.fromBase64(encryptionKey));
    utils.assert(account.authToken !== null, 'account has no authToken');
  }
};


