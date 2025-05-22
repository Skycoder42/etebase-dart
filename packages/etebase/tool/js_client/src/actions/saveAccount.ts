import type { SignedInActionConfig, SignedInAction } from "../util/action";

type SaveAccountAction = SignedInAction & {
  encryptionKey: string;
};

export const saveAccountConfig: SignedInActionConfig<SaveAccountAction> = {
  name: 'saveAccount',
  callback: async ({ etebase, account, action: { encryptionKey } }) => {
    const savedAccount = await account.save(etebase.fromBase64(encryptionKey));
    console.assert(savedAccount.length > 0, 'account data is empty', account);
    return savedAccount;
  }
};
