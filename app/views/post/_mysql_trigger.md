<%#
+++
date = "2017-04-06T16:54:51Z"
draft = false
title = "[大っ嫌い]mysql triggerの罠[求）絶滅]"
categories = ["mysql"]
+++
%>

### エラー例

```
2017-03-29 19:19:03 (INFO) /hoge exception 'PDOException' with message 'SQLSTATE[42000]: Syntax error or access violation: 1142 TRIGGER command denied to user 'hoge'@'localhost' for table 'present_entry'' in /hoge/vendor/zendframework/zend-db/src/Adapter/Driver/Pdo/Statement.php:239
Next exception 'Zend\Db\Adapter\Exception\InvalidQueryException' with message 'Statement could not be executed (42000 - 1142 - TRIGGER command denied to user 'hoge'@'localhost' for table 'present_entry')' in /hoge/vendor/zendframework/zend-db/src/Adapter/Driver/Pdo/Statement.php:244
```

### 原因

A. `TRIGGER`の設定をしています。

db(mysql)上の設定であり、プログラム上ではわからない動作です・・。

### 確認方法

```
SHOW TRIGGERS;
```


### trigger 設定例

```
# present_entryにレコードが追加された際、log_present_entryにもコピーします。
DROP TRIGGER IF EXISTS trg_ins_present_entry;
DELIMITER $$
CREATE TRIGGER trg_ins_present_entry AFTER INSERT
ON present_entry FOR EACH ROW
BEGIN
 INSERT INTO log_present_entry SET
  `member_id`=NEW.`member_id`,
  `cmp_id`=NEW.`cmp_id`,
  `present_id`=NEW.`present_id`,
  `entry_dt`=NEW.`entry_dt`,
  `result`=NEW.`result`,
  `rec_no`=NEW.`rec_no`,
  `status`=NEW.`status`,
  `update_dt`=NEW.`update_dt`
  ;
 END
$$
DELIMITER ;

# present_entryの更新がされた際、log_present_entryも更新します。
DROP TRIGGER IF EXISTS trg_upd_present_entry;
DELIMITER $$
CREATE TRIGGER trg_upd_present_entry AFTER UPDATE
ON present_entry FOR EACH ROW
BEGIN
 UPDATE log_present_entry SET
  `member_id`=NEW.`member_id`,
  `cmp_id`=NEW.`cmp_id`,
  `present_id`=NEW.`present_id`,
  `entry_dt`=NEW.`entry_dt`,
  `result`=NEW.`result`,
  `rec_no`=NEW.`rec_no`,
  `status`=NEW.`status`,
  `update_dt`=NEW.`update_dt`
  WHERE
  `member_id`=OLD.`member_id` and
  `cmp_id`=OLD.`cmp_id` and
  `present_id`=OLD.`present_id`and
  `entry_dt`=OLD.`entry_dt`
  ;
 END
$$
DELIMITER ;
```


