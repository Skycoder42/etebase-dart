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
import { testUtils } from './util/test';
import { createCollectionConfig } from './actions/createCollection';
import { updateCollectionConfig } from './actions/updateCollection';
import { restoreCollectionConfig } from './actions/restoreCollection';
import { saveCollectionConfig } from './actions/saveCollection';
import { listItemsConfig } from './actions/listItems';
import { validateItemConfig } from './actions/validateItem';
import { createItemConfig } from './actions/createItem';
import { updateItemConfig } from './actions/updateItem';
import { restoreItemConfig } from './actions/restoreItem';
import { saveItemConfig } from './actions/saveItem';
import { validatePubkeyConfig } from './actions/validatePubkey';
import { acceptInvitationConfig } from './actions/acceptInvitation';
import { inviteConfig } from './actions/invite';

const _run = async (action: Action, config: AnyActionConfig): Promise<boolean> => {
  if (action.action !== config.name) {
    return false;
  }

  const result = await run(etebase, testUtils, action, config);
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
  // account
  didRun = didRun || await _run(action, signInConfig);
  didRun = didRun || await _run(action, signUpConfig);
  didRun = didRun || await _run(action, saveAccountConfig);
  didRun = didRun || await _run(action, restoreAccountConfig);
  // collection
  didRun = didRun || await _run(action, listCollectionsConfig);
  didRun = didRun || await _run(action, validateCollectionConfig);
  didRun = didRun || await _run(action, createCollectionConfig);
  didRun = didRun || await _run(action, updateCollectionConfig);
  didRun = didRun || await _run(action, restoreCollectionConfig);
  didRun = didRun || await _run(action, saveCollectionConfig);
  // item
  didRun = didRun || await _run(action, listItemsConfig);
  didRun = didRun || await _run(action, validateItemConfig);
  didRun = didRun || await _run(action, createItemConfig);
  didRun = didRun || await _run(action, updateItemConfig);
  didRun = didRun || await _run(action, restoreItemConfig);
  didRun = didRun || await _run(action, saveItemConfig);
  // sharing
  didRun = didRun || await _run(action, validatePubkeyConfig);
  didRun = didRun || await _run(action, acceptInvitationConfig);
  didRun = didRun || await _run(action, inviteConfig);

  if (!didRun) {
    throw new Error(`Did not found any action matching: ${action.action}`);
  }
};

main();
