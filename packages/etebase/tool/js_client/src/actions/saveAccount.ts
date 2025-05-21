// import { runSignedIn } from "../util/run";
// import * as Etebase from 'etebase';

// type SaveAccountAction = {
//   username: string;
//   password: string;
//   encryptionKey: string;
// };

// runSignedIn<SaveAccountAction>(async (account, { encryptionKey }) => {
//   const savedAccount = await account.save(Etebase.fromBase64(encryptionKey));
//   console.assert(savedAccount.length > 0, 'account data is empty', account);
//   return savedAccount;
// });
