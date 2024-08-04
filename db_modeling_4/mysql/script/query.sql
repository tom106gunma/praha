-- 配信が必要なリマインダーの情報を取得
SELECT
	U.slack_user_id,
	REM.channel_name,
	REM.message,
	RER.is_complete,
	REQ.send_time
FROM reminder_queue REQ
INNER JOIN reminder_recipients RER on  RER.id = REQ.reminder_recipient_id
INNER JOIN reminders REM on REM.id = RER.reminder_id
INNER JOIN users U on U.id = RER.user_id
WHERE
	REQ.status = 'pending'
	and RER.is_complete = FALSE
	and REQ.send_time <= NOW();


-- 送信が完了したらreminder_queueのstatusを更新
UPDATE reminder_queue
SET status = 'sent'
WHERE id = 1;

-- タスクが完了していなければ次のreminder_queueをセット
-- セットするために必要な情報を取得
SELECT
	REM.id,
	U.slack_user_id,
	REM.frequency_type_id,
    REM.frequency_value
FROM reminder_recipients RER
INNER JOIN reminders REM on REM.id = RER.reminder_id
INNER JOIN users U on U.id = RER.user_id
WHERE REM.id = 'REM000001'
and RER.is_complete = FALSE;
