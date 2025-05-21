import * as etebase from 'etebase';
import { readFileSync, writeFileSync } from 'fs';
import { Action, ActionCallback, SignedInAction, SignedInActionCallback } from './util/action';
import { signInActionName, signInAction } from './actions/signIn';

const _run = async <TAction extends Action>(action: Action, name: string, callback: ActionCallback<TAction>): Promise<boolean> => {
  if (action.action !== name) {
    return false;
  }

  const result = await callback({ etebase, action: action as TAction });
  if (result) {
    writeFileSync(1, JSON.stringify(result));
  }

  return true;
}

const _runSignedIn = async <TAction extends SignedInAction>(action: Action, name: string, callback: SignedInActionCallback<TAction>): Promise<boolean> => {
  return await _run<TAction>(action, name, async ({ etebase, action }) => {
    const account = await etebase.Account.login(action.username, action.password, action.serverUrl);
    return await callback({ etebase, account, action });
  });
}

const main = async () => {
  await etebase.ready;

  const stdin = readFileSync(0);
  const action = JSON.parse(stdin.toString()) as Action;

  let didRun = false;
  didRun = didRun || await _run(action, signInActionName, signInAction);

  if (!didRun) {
    throw new Error(`Did not found any action matching: ${action.action}`);
  }
};

main();
