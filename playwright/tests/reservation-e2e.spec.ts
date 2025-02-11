import { test, expect } from '@playwright/test';

test('宿泊予約ページに移動し、フォームの入力→予約内容の確認→予約完了まで実行できるか確認する', async ({ page }) => {

  await page.goto('https://hotel-example-site.takeyaqa.dev/ja/');
  await page.getByRole('link', { name: '宿泊予約' }).click();
  const page1Promise = page.waitForEvent('popup');
  await page.locator('.card-body > .btn').first().click();

  const page1 = await page1Promise;
  await page1.getByRole('textbox', { name: '宿泊日 必須' }).click();
  await page1.getByRole('link', { name: '22' }).click();
  const checkInDate = await page1.locator('#date').inputValue();
  const term = await page1.locator('#term').inputValue();
  const headCount = await page1.locator('#head-count').inputValue();
  await page1.getByRole('checkbox', { name: '朝食バイキング' }).check();
  await page1.getByRole('textbox', { name: '氏名 必須' }).click();
  await page1.getByRole('textbox', { name: '氏名 必須' }).fill('tom106');
  await page1.getByLabel('確認のご連絡 必須').selectOption('no');
  await page1.getByRole('textbox', { name: 'ご要望・ご連絡事項等ありましたらご記入ください' }).click();
  await page1.getByRole('textbox', { name: 'ご要望・ご連絡事項等ありましたらご記入ください' }).fill('test');

  const totalBill = await page1.locator('#total-bill').innerText();

  let [checkInYear, checkInMonth, checkInDay] = checkInDate.split('/');
  checkInMonth = parseInt(checkInMonth, 10).toString();
  checkInDay = parseInt(checkInDay, 10).toString();

  const date = new Date(parseInt(checkInYear, 10), parseInt(checkInMonth, 10) - 1, parseInt(checkInDay, 10));
  date.setDate(date.getDate() + 1);
  const checkOutYear = date.getFullYear().toString();
  const checkOutMonth = (date.getMonth() + 1).toString();
  const checkOutDay = date.getDate().toString();

  await page1.locator('[data-test="submit-button"]').click();

  await expect(page1.locator('#total-bill')).toHaveText(`合計 ${totalBill}（税込み）`);
  await expect(page1.locator('#term')).toHaveText(`${checkInYear}年${checkInMonth}月${checkInDay}日 〜 ${checkOutYear}年${checkOutMonth}月${checkOutDay}日 ${term}泊`);
  await expect(page1.locator('#head-count')).toHaveText(`${headCount}名様`);
  await expect(page1.locator('#plans')).toHaveText('朝食バイキング');
  await expect(page1.locator('#username')).toHaveText('tom106様');
  await expect(page1.locator('#contact')).toHaveText('希望しない');
  await expect(page1.locator('#comment')).toHaveText('test');

  await page1.getByRole('button', { name: 'この内容で予約する' }).click();
});
