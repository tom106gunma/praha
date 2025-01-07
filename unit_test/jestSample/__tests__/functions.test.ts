import { sumOfArray, asyncSumOfArray} from "../functions";

// todo: ここに単体テストを書いてみましょう！
describe("sumOfArrayのテスト", () => {
  test("[1,1]を渡したら2になること", () => {
    expect(sumOfArray([1,1])).toBe(2);
  });

  test("[]を渡したら例外が発生すること", () => {
    expect(() => sumOfArray([])).toThrow();
  });
  // 無名関数でラップする。toThrowが呼ばれる前にエラーで停止してしまうから。

  test("マイナスが含まれていても正しく合計されること", () => {
    expect(sumOfArray([-1, -2, 3])).toBe(0);
  });

  test("1つの要素しかない場合、その値が返ること", () => {
    expect(sumOfArray([14])).toBe(14);
  });

});

describe("asyncSumOfArrayのテスト", () => {
  test("[1,1]を渡したら2になること", async () => {
    expect(await asyncSumOfArray([1,1])).toBe(2);
  });

  test("[]を渡したら例外が発生すること", async () => {
    await expect(() => asyncSumOfArray([])).rejects.toThrow();
  });

});
