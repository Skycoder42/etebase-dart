import type { SignedInActionConfig, SignedInAction } from "../util/action";

type SaveAccountAction = SignedInAction & {
  encryptionKey: string;
};

export const saveAccountConfig: SignedInActionConfig<SaveAccountAction> = {
  signedIn: true,
  name: 'saveAccount',
  callback: async ({ etebase, utils, account, action: { encryptionKey } }) => {
    const savedAccount = await account.save(etebase.fromBase64(encryptionKey));
    utils.assert(savedAccount.length > 0, 'account data is empty');
    return savedAccount;
  }
};
