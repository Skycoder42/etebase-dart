import { run } from "../util/run";
import * as Etebase from 'etebase';

type RestoreAccountAction = {
  data: string;
  encryptionKey: string;
};

run<RestoreAccountAction>(async (_, { data, encryptionKey }) => {
  const account = await Etebase.Account.restore(data, Etebase.fromBase64(encryptionKey));
  console.assert(account.authToken, 'account has not authToken', account);
});
