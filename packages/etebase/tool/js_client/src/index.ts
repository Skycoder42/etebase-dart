import * as etebase from 'etebase';
import { readFileSync, writeFileSync } from 'fs';
import { Action, ActionConfig, SignedInAction, SignedInActionConfig } from './util/action';
import { signInConfig } from './actions/signIn';
import { signUpConfig } from './actions/signUp';
import { restoreAccountConfig } from './actions/restoreAccount';
import { saveAccountConfig } from './actions/saveAccount';

const _run = async <TAction extends Action>(action: Action, config: ActionConfig<TAction>): Promise<boolean> => {
  if (action.action !== config.name) {
    return false;
  }

  const result = await config.callback({ etebase, action: action as TAction });
  if (result) {
    writeFileSync(1, JSON.stringify(result));
  }

  return true;
}

const _runSignedIn = async <TAction extends SignedInAction>(action: Action, config: SignedInActionConfig<TAction>): Promise<boolean> => {
  return await _run<TAction>(action, {
    name: config.name,
    callback: async ({ etebase, action }) => {
      const account = await etebase.Account.login(action.username, action.password, action.serverUrl);
      return await config.callback({ etebase, account, action });
    }
  });
}

const main = async () => {
  await etebase.ready;

  const stdin = readFileSync(0);
  const action = JSON.parse(stdin.toString()) as Action;

  let didRun = false;
  didRun = didRun || await _run(action, signInConfig);
  didRun = didRun || await _run(action, signUpConfig);
  didRun = didRun || await _runSignedIn(action, saveAccountConfig);
  didRun = didRun || await _run(action, restoreAccountConfig);

  if (!didRun) {
    throw new Error(`Did not found any action matching: ${action.action}`);
  }
};

main();
