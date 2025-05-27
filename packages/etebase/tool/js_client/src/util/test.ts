import { TestUtils } from "./action";

export const testUtils: TestUtils = {
  assert: (condition: boolean, message: string) => {
    if (!condition) {
      throw new Error(`Assertion Failed: ${message}`);
    }
  }
};
