import { sumOfArray, asyncSumOfArray, asyncSumOfArraySometimesZero, getFirstNameThrowIfLong} from "../functions";
import { NameApiService } from "../nameApiService";

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

describe("asyncSumOfArraySometimesZeroのテスト", () => {
  // save をモック化
  const mockDatabase = {
    save: jest.fn()
  };
  test("[1,1]を渡したら2になること", async () => {
    const numbers = [1, 1];
    expect(await asyncSumOfArraySometimesZero(numbers, mockDatabase)).toBe(2);
  });

  test("[]を渡したらエラーとなり、0になること", async () => {
    expect(await asyncSumOfArraySometimesZero([], mockDatabase)).toBe(0);
  });

  test("saveが失敗したら、0になること", async () => {
    // save が失敗するようにモック化
    const mockErrorDatabase = {
      save: jest.fn(() => {
        throw new Error("fail!");
      })
    };
    expect(await asyncSumOfArraySometimesZero([], mockErrorDatabase)).toBe(0);
  });
});

jest.mock("../nameApiService");
describe("getFirstNameThrowIfLongのテスト", () => {
  const mockNameApiService = new NameApiService() as jest.Mocked<NameApiService>;
  mockNameApiService.getFirstName.mockResolvedValue("tom");

  test("名前が返されること", async () => {
    expect(await getFirstNameThrowIfLong(4, mockNameApiService)).toBe("tom");
  });

  test("maxNameLength を超えた場合、エラーが返される", async () => {
    await expect(getFirstNameThrowIfLong(2, mockNameApiService)).rejects.toThrow(
      "first_name too long"
    );
  });
});
