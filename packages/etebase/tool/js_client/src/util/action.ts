import * as _Etebase from 'etebase';

export type Etebase = typeof _Etebase;

export type Action = {
  action: string;
}

type ActionCallbackParam<T extends Action> = {
  etebase: Etebase;
  action: T;
};

export type ActionCallback<T extends Action> = (_: ActionCallbackParam<T>) => Promise<any>;

export type SignedInAction = Action & {
  username: string;
  password: string;
  serverUrl?: string;
};

type SignedInActionCallbackParam<T extends Action> = {
  etebase: Etebase;
  account: _Etebase.Account;
  action: T;
};

export type SignedInActionCallback<T extends SignedInAction> = (_: SignedInActionCallbackParam<T>) => Promise<any>;

export type ActionConfig<T extends Action> = {
  name: string;
  callback: ActionCallback<T>
}

export type SignedInActionConfig<T extends SignedInAction> = {
  name: string;
  callback: SignedInActionCallback<T>
}
