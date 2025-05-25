import { OutputFormat, type ItemMetadata } from "etebase";
import type { SignedInActionConfig, SignedInAction } from "../util/action";

type ValidateCollectionAction = SignedInAction & {
  uid: string;
  meta?: ItemMetadata;
  content?: string;
  isDeleted?: boolean;
};

export const validateCollectionConfig: SignedInActionConfig<ValidateCollectionAction> = {
  signedIn: true,
  name: 'validateCollection',
  callback: async ({ etebase, account, action: { uid, meta, content, isDeleted } }) => {
    const cm = account.getCollectionManager();
    const col = await cm.fetch(uid);
    console.assert(col.verify(), 'Unable to verify collection');

    if (typeof meta !== "undefined") {
      const colMeta = col.getMeta();
      console.assert(
        JSON.stringify(colMeta) === JSON.stringify(meta),
        'Collection metadata does not match (Expected: %o, Actual: %o)',
        colMeta,
        meta
      );
    }

    if (typeof content !== "undefined") {
      const colContent = await col.getContent(OutputFormat.String);
      console.assert(colContent === content,
        'Collection content does not match (Expected: %s, Actual: %s)',
        colContent,
        content
      );
    }

    if (typeof isDeleted !== "undefined") {
      console.assert(
        col.isDeleted == isDeleted,
        'Collection deletion state does not match (Expected: %s, Actual: %s)',
        col.isDeleted.toString(),
        isDeleted.toString()
      );
    }
  }
};
