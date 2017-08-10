<%#
+++
date = "2016-11-21T11:21:51Z"
draft = false
title = "MYSQLのレプリケーション復旧手順"
categories = ["mysql"]
+++
%>

### 概要

+ サーバーが落ちたなどでレプリケーションがとまった際の復旧
+ また、オペミスにより論理破壊した場合の手順

---

### 1. レプリケーション停止の確認方法

slave側のmysqlに接続し、`show slave status\G`をたたく。

`Slave_IO_Running`、`Slave_SQL_Running`のどちらかがNoであればレプリケーションできていない

この時点で`アプリケーションからアクセスがこないようにする`こと！

---


### 2. 復旧手順

masterより進んでいないなら`start slave`で解決

※) 同期が完了するまでアプリケーションからのアクセスがこないようにしておくことを推奨

---

### 2'. 論理破壊時の復旧手順

masterよりすすんでしまっており、修正不可能な場合の手順。

無停止ではなく停止して安全に作業をする前提。

手順こちら

1. メンテナンス等でアクセス不可にする。管理ツール等サービスに直接関係ないがアクセスがくるものは、apache等のwebサーバーをとめておくと安心
1. masterからmysqldump
1. メンテナンス解除
1. slaveへインポート
1. change master to
1. start slave



#### 2'-1. masterからmysqldump

サーバーのメモリが高ければgzipはいらなそう。（空き容量と相談）

12コア128GBのヒュージョンドライブでgzipしたら、3~4コアしか使われず、CPU使用率が100%にはりついてしまった。

i/oもiがほぼなかったので、全部メモリにのってたよう。

前例として、上記スペックで200GBのDBをダンプするのに1時間しない程度の処理時間だった。

```
mysqldump -uroot -p --opt --single-transaction --master-data=2 --all-databases | gzip > ~/db_dump.sql.gz
```

オプション等 | 説明
--- | ---
opt | 高速にdumpするためのオプション。--add-drop-table --add-locks --create-options --disable-keys --extended-insert --lock-tables --quick --set-charset
single-transaction | トランザクションをはさんでmysqldumpを行う
master-data | change master toに必要な情報を出力してくれる
all-databases | DB指定があるなら不要
add-drop-table | DROP TABLE文を含める
add-locks | LOCK TABLES と UNLOCK TABLES ステートメントで各テーブルダンプを囲む
create-options | MySQL に固有なテーブルオプションを含める
disable-keys | 各テーブルについて、キーを無効にするステートメントおよび有効にするステートメントで INSERT ステートメントを囲む
extended-insert | 複数の VALUES リストを含む、複数行 INSERT 構文を使用
lock-tables | テーブルをダンプする前にロックする
quick | サーバーからのテーブルについて、一度に 1 行ずつ取得
set-charset | SET NAMES default_character_set を出力に追加

[ver5.6のドキュメント](https://dev.mysql.com/doc/refman/5.6/ja/mysqldump.html)


---


#### 2'-2. slaveにログインし、インポートします。

masterサーバで作成したzipをslaveサーバにおくる。

CHANGE MASTER TOに必要な情報は出力できているのでmaster（と他のslave）をサービスインしてよい。

```
cat ~/db_dump.sql.gz | gunzip | mysql -u root -p
```


---


#### 2'-3. change master to

出力されたファイルのうえのほうにCHANGE MASTER TOの情報(binログファイルとポジション)があるので拾う

```
cat ~/db_dump.sql.gz | gunzip | head -n 100 | grep "CHANGE MASTER"
```

host, userなどを追記して実行

```
CHANGE MASTER TO MASTER_LOG_FILE='mysql-bin.nnnnn', MASTER_LOG_POS=nnnnnnnnnn, MASTER_HOST='hoge', MASTER_USER='hoge', MASTER_PASSWORD='hoge';
```


---


#### 2'-4. slave start

```
slave start
```

`show slave status`で`Slave_IO_Running`、`Slave_SQL_Running`がONになっていることを確認

`behindなんたら`の数値がじょじょに減り0になったら復旧完了


---


### メモ


現在ダンプしているテーブル名を確認

`mysql > show full processlist`

DBの各テーブルサイズを確認

`ls -lha /fio/mysql/db_name/`

データ整形して進捗を確認

io割合や　idle/wait割合確認

`vmstat 1`
