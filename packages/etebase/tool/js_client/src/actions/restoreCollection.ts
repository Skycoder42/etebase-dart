import type { ItemMetadata } from "etebase";
import type { SignedInActionConfig, SignedInAction } from "../util/action";

type RestoreCollectionAction = SignedInAction & {
  data: string;
  meta?: ItemMetadata;
  content?: string;
  noContent: boolean;
  isDeleted?: boolean;
};

export const restoreCollectionConfig: SignedInActionConfig<RestoreCollectionAction> = {
  signedIn: true,
  name: 'restoreCollection',
  callback: async ({ utils, etebase, account, action: { data, meta, content, noContent, isDeleted } }) => {
    const cm = account.getCollectionManager();
    console.warn("### cacheLoad");
    const col = cm.cacheLoad(etebase.fromBase64(data));
    console.warn("### verify");
    utils.assert(col.verify(), 'Unable to verify collection');

    if (typeof meta !== "undefined") {
      console.warn("### getMeta");
      const colMeta = col.getMeta();
      utils.assert(
        JSON.stringify(colMeta) === JSON.stringify(meta),
        `Collection metadata does not match (Expected: ${JSON.stringify(meta)}, Actual: ${JSON.stringify(colMeta)})`,
      );
    }

    if (noContent) {
      console.warn("### isMissingContent");
      utils.assert(col.item.isMissingContent, "Item should be missing content, but is not");
      try {
        console.warn("### try getContent");
        const colContent = await col.getContent();
        utils.assert(false, `Expected getContent to throw, but it returned ${etebase.toBase64(colContent)}`);
      } catch (e: any) {
        utils.assert(e instanceof etebase.MissingContentError, `Expected content to throw MissingContentError, but did throw ${e}`);
      }
    } else if (typeof content !== "undefined") {
      console.warn("### getContent");
      const colContent = await col.getContent();
      const encodedContent = etebase.toBase64(colContent);
      utils.assert(
        encodedContent === content,
        `Collection content does not match (Expected: ${content}, Actual: ${encodedContent})`,
      );
    }

    if (typeof isDeleted !== "undefined") {
      console.warn("### isDeleted");
      utils.assert(
        col.isDeleted == isDeleted,
        `Collection deletion state does not match (Expected: ${isDeleted}, Actual: ${col.isDeleted})`,
      );
    }
  }
};
