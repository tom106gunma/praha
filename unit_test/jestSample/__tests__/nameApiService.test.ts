import { NameApiService } from "../nameApiService";
import axios from "axios";

jest.mock("axios");
const mockAxios = jest.mocked(axios);

describe("NameApiServiceのテスト", () => {
  test("名前が返されること", async () => {
    mockAxios.get.mockResolvedValueOnce({
      data: { first_name: "tom" },
    });
    const nameApiService = new NameApiService();
    expect(await nameApiService.getFirstName()).toBe("tom");
  });

  test("MAX_LENGTH を超えた場合、エラーが返される", async () => {
    mockAxios.get.mockResolvedValueOnce({
      data: { first_name: "tom106" },
    });
    const nameApiService = new NameApiService();
    await expect(nameApiService.getFirstName()).rejects.toThrow(
      "firstName is too long!"
    );
  });
});
