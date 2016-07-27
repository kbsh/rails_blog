<%#
+++
date = "2016-07-19T11:11:51Z"
draft = false
title = "[linux]グループやユーザーの作成、削除"
categories = ["linux"]
+++
%>

### グループの作成

```
$ sudo groupadd -g {グループID} {グループ名}
```


作成確認

```
$ cat /etc/group
{グループ名}:x:{グループID}:{サブグループ所属アカウント}
```

サブグループ所属アカウントはデフォルトでは空

---

### ユーザーの追加

```
$ sudo useradd -g {グループID} -G {サブグループID} -u {ユーザーID} {ユーザー名}
```

作成確認

```
$ cat /etc/passwd
{ユーザー名}:x:{ユーザーID}:{グループID}::{ホームディレクトリ}
```

---

### ユーザー、グループの削除

```
$ userdel {ユーザー名}
```

ホームディレクトリ、メールファイルは削除されないため、下記コマンドもたたくこと

```
$ sudo rm -rf /home/{ユーザー名}/
$ sudo rm -f /var/spool/mail/{ユーザー名}
```
---

### root権限を付与


```
$ sudo visudo
+ {ユーザー名}        ALL=(ALL)       NOPASSWD: ALL
```
