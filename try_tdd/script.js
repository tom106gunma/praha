// CLI 実行用の処理
if (require.main === module) {
  const method = process.argv[2];
  const numbers = process.argv.slice(3).map(Number);

  try {
    const result = calculate(method, numbers);
    console.log(result);
  } catch (error) {
    console.error(error.message);
    process.exit(1);
  }
}

function calculate(method, numbers) {
  const isAllNumbers = numbers.every(item => typeof item === 'number');

  if (numbers.length < 1 || numbers.length > 30) {
    throw new Error("引数は1個以上30個以下にしてください。");
  } else if(!isAllNumbers){
    throw new Error("引数は数字のみを指定してください。");
  }

  let result;

  switch (method) {
    case 'add':
      result = numbers.reduce((a, b) => a + b);
      if(result > 1000){
        result = 'too big'
      }
      break;

    case 'multiply':
      result = numbers.reduce((a, b) => a * b);
      if(result > 1000){
        result = 'big big number';
      }
      break;

    case 'subtract':
      result = numbers.reduce((a, b) => a - b);
      if(result < 0){
        result = 'negative number';
      }
      break;

    case 'divide':
      result = Math.floor((numbers.reduce((a, b) => a / b)) * 100) / 100;
      break;

    default:
      result = `${method} はありません。add, subtract, multiply, divide の中から指定してください。`;
  }

  return result;
}

module.exports = calculate;
