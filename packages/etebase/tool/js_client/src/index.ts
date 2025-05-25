import * as etebase from 'etebase';
import { readFileSync, writeFileSync } from 'fs';
import { Action, AnyActionConfig } from './util/action';
import { run } from './util/run';
import { signInConfig } from './actions/signIn';
import { signUpConfig } from './actions/signUp';
import { restoreAccountConfig } from './actions/restoreAccount';
import { saveAccountConfig } from './actions/saveAccount';
import { listCollectionsConfig } from './actions/listCollections';
import { validateCollectionConfig } from './actions/validateCollection';

const _run = async (action: Action, config: AnyActionConfig): Promise<boolean> => {
  if (action.action !== config.name) {
    return false;
  }

  const result = await run(etebase, action, config);
  if (result) {
    writeFileSync(1, JSON.stringify(result));
  }

  return true;
}

const main = async () => {
  await etebase.ready;

  const stdin = readFileSync(0);
  const action = JSON.parse(stdin.toString()) as Action;

  let didRun = false;
  didRun = didRun || await _run(action, signInConfig);
  didRun = didRun || await _run(action, signUpConfig);
  didRun = didRun || await _run(action, saveAccountConfig);
  didRun = didRun || await _run(action, restoreAccountConfig);
  didRun = didRun || await _run(action, listCollectionsConfig);
  didRun = didRun || await _run(action, validateCollectionConfig);

  if (!didRun) {
    throw new Error(`Did not found any action matching: ${action.action}`);
  }
};

main();
