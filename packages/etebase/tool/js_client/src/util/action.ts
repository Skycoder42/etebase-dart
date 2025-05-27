import * as _Etebase from 'etebase';

export type Etebase = typeof _Etebase;

export type TestUtils = {
  assert: (condition: boolean, message: string) => void;
}

export type Action = {
  action: string;
}

type ActionCallbackParam<T extends Action> = {
  etebase: Etebase;
  utils: TestUtils;
  action: T;
};

export type ActionCallback<T extends Action> = (_: ActionCallbackParam<T>) => Promise<any>;

export type SignedInAction = Action & {
  username: string;
  password: string;
  serverUrl?: string;
};

type SignedInActionCallbackParam<T extends SignedInAction> = ActionCallbackParam<T> & {
  account: _Etebase.Account;
};

export type SignedInActionCallback<T extends SignedInAction> = (_: SignedInActionCallbackParam<T>) => Promise<any>;

export type ActionConfig<T extends Action> = {
  signedIn?: false | null;
  name: string;
  callback: ActionCallback<T>
}

export type SignedInActionConfig<T extends SignedInAction> = {
  signedIn: true;
  name: string;
  callback: SignedInActionCallback<T>
}

export type AnyActionConfig = ActionConfig<any> | SignedInActionConfig<any>;
