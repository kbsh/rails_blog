<%#
+++
date = "2017-04-6T16:54:51Z"
draft = false
title = "[mysql]外部キー関連テーブルの調べ方"
categories = ["mysql"]
+++
%>

### 外部キーの子を調べる

```
show create table [テーブル名]
```

### 外部キーの親を調べる

```
-- 親があるテーブルをすべて表示
select * from information_schema.key_column_usage where constraint_schema = [スキーマ名] and REFERENCED_TABLE_NAME is not NULL\G
-- 親がhogeテーブルのテーブルをすべて表示
select * from information_schema.key_column_usage where constraint_schema = [スキーマ名] and REFERENCED_TABLE_NAME = [テーブル名] \G
```
