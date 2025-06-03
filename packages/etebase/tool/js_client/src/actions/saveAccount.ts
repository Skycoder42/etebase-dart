import type { ActionConfig, Action } from "../util/action";

type SaveAccountAction = Action & {
  username: string;
  password: string;
  serverUrl?: string;
  encryptionKey: string;
};

export const saveAccountConfig: ActionConfig<SaveAccountAction> = {
  name: 'saveAccount',
  callback: async ({ etebase, utils, action: { username, password, serverUrl, encryptionKey } }) => {
    const account = await etebase.Account.login(username, password, serverUrl);
    const savedAccount = await account.save(etebase.fromBase64(encryptionKey));
    utils.assert(savedAccount.length > 0, 'account data is empty');
    return savedAccount;
  }
};
