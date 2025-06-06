import type { SignedInActionConfig, SignedInAction } from "../util/action";

type ValidatePubkeyAction = SignedInAction & {
  pubkey: string;
  fingerprint: string;
};

export const validatePubkeyConfig: SignedInActionConfig<ValidatePubkeyAction> = {
  type: 'signedIn',
  name: 'validatePubkey',
  callback: async ({ etebase, utils, account, action: { pubkey, fingerprint } }) => {
    const im = account.getInvitationManager();

    const jsPubKey = im.pubkey;
    const encodedJsPubKey = etebase.toBase64(jsPubKey);
    utils.assert(
      encodedJsPubKey === pubkey,
      `Pubkey does not match (Expected: ${pubkey}, Actual: ${encodedJsPubKey})`,
    );

    const jsFingerprint = etebase.getPrettyFingerprint(im.pubkey);
    utils.assert(
      jsFingerprint === fingerprint,
      `Pubkey fingerprint does not match (Expected: ${fingerprint}, Actual: ${jsFingerprint})`,
    );
  }
};
