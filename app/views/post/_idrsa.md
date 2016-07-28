<%#
+++
date = "2016-07-22T14:34:51Z"
draft = false
title = "鍵作成、鍵交換"
categories = ["linux"]
+++
%>

### 鍵作成手順

```
    1  cd
    2  mkdir .ssh
    3  ls -la
    4  chmod 700 .ssh/
    5  cd .ssh/
    6  ls -la
    7  ssh-keygen -t rsa
    8  cp id_rsa.pub authorized_keys
    9  ls -la
   10  chmod 600 authorized_keys id_rsa.pub
   11  cat id_rsa
```

`authorized_keys`が既に存在する場合はcpせずに追記すること

---

### 鍵交換

+ ssh
  + 作成した公開鍵(`id_rsa.pub`)をコピーし、交換先（接続先）の`~/.ssh/authorized_keys`に登録すればよい。
+ github
  + 作成した秘密鍵を[github setting](https://github.com/settings/keys)に登録する。
  + サーバー側の公開鍵ファイル名を`authorized_keys`に追記すること
  + サーバー側の秘密鍵の名前を`id_rsa`から変更する場合は`~/.ssh/config`の設定が必要
