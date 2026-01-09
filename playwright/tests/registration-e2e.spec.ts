import { test, expect } from '@playwright/test';


test('会員登録を行い、内容を確認する', async ({ page }) => {
  await page.goto('https://hotel-example-site.takeyaqa.dev/ja/');
  await page.getByRole('link', { name: '会員登録' }).click();
  await page.getByRole('textbox', { name: 'メールアドレス 必須' }).click();
  await page.getByRole('textbox', { name: 'メールアドレス 必須' }).fill('test@example.com');
  await page.getByRole('textbox', { name: 'パスワード 必須' }).click();
  await page.getByRole('textbox', { name: 'パスワード 必須' }).fill('12345678');
  await page.getByRole('textbox', { name: 'パスワード（確認） 必須' }).click();
  await page.getByRole('textbox', { name: 'パスワード（確認） 必須' }).fill('12345678');
  await page.getByRole('textbox', { name: '氏名 必須' }).click();
  await page.getByRole('textbox', { name: '氏名 必須' }).fill('test');

  await page.getByRole('button', { name: '登録' }).click();

  await expect(page.locator('#email')).toHaveText('test@example.com');
  await expect(page.locator('#username')).toHaveText('test');
});
