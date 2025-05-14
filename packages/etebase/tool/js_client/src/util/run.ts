import { readFileSync, writeFileSync } from "fs";
import * as Etebase from 'etebase';

export const run = async <TAction>(main: (serverUrl: string | undefined, action: TAction) => Promise<any>): Promise<void> => {
  await Etebase.ready;

  const serverUrl = process.argv.at(2);

  const stdin = readFileSync(0);
  const action = JSON.parse(stdin.toString()) as TAction;

  const result = await main(serverUrl, action);
  if (result) {
    writeFileSync(1, JSON.stringify(result));
  }
};

type SignedInAction = {
  username: string;
  password: string;
};

export const runSignedIn = async <TAction extends SignedInAction>(main: (account: Etebase.Account, action: TAction) => Promise<any>): Promise<void> => {
  await Etebase.ready;

  const serverUrl = process.argv.at(2);

  const stdin = readFileSync(0);
  const action = JSON.parse(stdin.toString()) as TAction;

  const account = await Etebase.Account.login(action.username, action.password, serverUrl);

  const result = await main(account, action);
  if (result) {
    writeFileSync(1, JSON.stringify(result));
  }
};
