const calculate = require('../script.js');

describe('addのテスト', () => {
  const method = 'add';

  test('add に 1 と 2 を渡したら 3 が返ってくる', () => {
    const args =  [method, [1, 2]];
    const result = calculate(...args);
    expect(result).toBe(3);
  });

  test('add に 999 と 1 を渡したら 1000 が返ってくる', () => {
    const args =  [method, [999, 1]];
    const result = calculate(...args);
    expect(result).toBe(1000);
  });

  test('add に 1000 と 1 を渡したら "too big" が返ってくる', () => {
    const args =  [method, [1000, 1]];
    const result = calculate(...args);
    expect(result).toBe("too big");
  });

  test('add に 500, 500, 50 を渡したら "too big" が返ってくる', () => {
    const args =  [method, [500, 500, 50]];
    const result = calculate(...args);
    expect(result).toBe("too big");
  });
});

describe('multiplyのテスト', () => {
  const method = 'multiply';

  test('multiply に 10 と 10 を渡したら 100 が返ってくる', () => {
    const args =  [method, [10, 10]];
    const result = calculate(...args);
    expect(result).toBe(100);
  });

  test('multiply に 50 と 30 を渡したら "big big number" が返ってくる', () => {
    const args =  [method, [50, 30]];
    const result = calculate(...args);
    expect(result).toBe("big big number");
  });
});

describe('subtractのテスト', () => {
  const method = 'subtract';

  test('subtract に 20 と 10 を渡したら 10 が返ってくる', () => {
    const args =  [method, [20, 10]];
    const result = calculate(...args);
    expect(result).toBe(10);
  });

  test('subtract に 10 と 20 を渡したら "negative number" が返ってくる', () => {
    const args =  [method, [10, 20]];
    const result = calculate(...args);
    expect(result).toBe("negative number");
  });

  test('subtract に 10 と 10 を渡したら 0 が返ってくる', () => {
    const args =  [method, [10, 10]];
    const result = calculate(...args);
    expect(result).toBe(0);
  });

  test('subtract に 50, 40, 20 を渡したら "negative number" が返ってくる', () => {
    const args =  [method, [50, 40, 20]];
    const result = calculate(...args);
    expect(result).toBe("negative number");
  });
});

describe('divideのテスト', () => {
  const method = 'divide';

  test('divide に 10 と 2 を渡したら 5 が返ってくる', () => {
    const args =  [method, [10, 2]];
    const result = calculate(...args);
    expect(result).toBe(5);
  });

  test('divide に 100 と 10 と 10 を渡したら 1 が返ってくる', () => {
    const args =  [method, [100, 10, 10]];
    const result = calculate(...args);
    expect(result).toBe(1);
  });

  test('divide に 10 と 3 を渡したら 3.33 が返ってくる', () => {
    const args =  [method, [10, 3]];
    const result = calculate(...args);
    expect(result).toBe(3.33);
  });

  test('divide に 5 と 2 を渡したら 2.50 が返ってくる', () => {
    const args =  [method, [5, 2]];
    const result = calculate(...args);
    expect(result).toBe(2.50);
  });

});

describe('引数のテスト', () => {
  const method = 'add';

  test('31個以上の引数(数字)を指定するとエラーが発生する', () => {
    const args = [method, Array(31).fill(1)];
    expect(() => calculate(...args)).toThrow('引数は1個以上30個以下にしてください。');
  });

  test('0個の引数(数字)を指定するとエラーが発生する', () => {
    const args = [method,[]];
    expect(() => calculate(...args)).toThrow('引数は1個以上30個以下にしてください。');
  });

  test('引数が数字以外だとエラーが発生する', () => {
    const args = [method, [1, 'a', 3]];
    expect(() => calculate(...args)).toThrow('引数は数字のみを指定してください。');
  });

  test('add, subtract, multiply, divide 以外を指定すると 「test はありません。add, subtract, multiply, divide の中から指定してください。が返ってくる', () => {
    const args = ['test', [1]];
    expect(calculate(...args)).toBe('test はありません。add, subtract, multiply, divide の中から指定してください。');
  });

});
