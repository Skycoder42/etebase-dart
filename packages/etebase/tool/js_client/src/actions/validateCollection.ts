import type { ItemMetadata } from "etebase";
import type { SignedInActionConfig, SignedInAction } from "../util/action";

type ValidateCollectionAction = SignedInAction & {
  uid: string;
  meta?: ItemMetadata;
  content?: string;
  isDeleted?: boolean;
};

export const validateCollectionConfig: SignedInActionConfig<ValidateCollectionAction> = {
  type: 'signedIn',
  name: 'validateCollection',
  callback: async ({ etebase, utils, account, action: { uid, meta, content, isDeleted } }) => {
    const cm = account.getCollectionManager();
    const col = await cm.fetch(uid);
    utils.assert(col.verify(), 'Unable to verify collection');

    if (typeof meta === "object" && meta !== null) {
      const colMeta = col.getMeta();
      utils.assert(
        JSON.stringify(colMeta) === JSON.stringify(meta),
        `Collection metadata does not match (Expected: ${JSON.stringify(meta)}, Actual: ${JSON.stringify(colMeta)})`,
      );
    }

    if (typeof content == "string") {
      const colContent = await col.getContent();
      const encodedContent = etebase.toBase64(colContent);
      utils.assert(
        encodedContent === content,
        `Collection content does not match (Expected: ${content}, Actual: ${encodedContent})`,
      );
    }

    if (typeof isDeleted === "boolean") {
      utils.assert(
        col.isDeleted == isDeleted,
        `Collection deletion state does not match (Expected: ${isDeleted}, Actual: ${col.isDeleted})`,
      );
    }
  }
};
