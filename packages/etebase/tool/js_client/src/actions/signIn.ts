import { run } from "../util/run";
import * as Etebase from 'etebase';

type SignInAction = {
  username: string;
  password: string;
};

run<SignInAction>(async (serverUrl, { username, password }) => {
  const account = await Etebase.Account.login(username, password, serverUrl);
  console.assert(account.authToken, 'account has not authToken', account);
});
