<%#
+++
date = "2016-07-27T16:09:51Z"
draft = false
title = "awsでsamba( ファイル共有サーバ )の設定"
categories = ["linux", "aws"]
+++
%>

## 概要

awsでと言ってますが、セキュリティ部分以外はawsじゃなくても一緒です。

+ sambaでec2サーバーのとあるディレクトリをファイルサーバーと化す
+ Basic認証をする
+ IP制限する


---

## sambaのインストール

```
$ cd /etc/yum.repos.d/
$ sudo wget http://ftp.sernet.de/pub/samba/3.5/centos/5/sernet-samba.repo
```

---

## confの設定

```
$ sudo vi /etc/samba/smb.conf
[global]
load printers = no
security = user
encrypt passwords = yes


[public]
comment = public space
path = /path/to
writable = Yes
```

+ [svn]とpathを書き換えること。
  + [svn]がシェア名となる。
  + pathの最終ディレクトリをシェア名とすること推奨。

---

## セキュリティの設定

sambaのポートを通るよう設定する必要がある。

1. `ec2`にアクセス
2. `セキュリティグループ`に遷移
3. インスタンスで設定しているセキュリティグループを選択
4. `インバウンド`タブを開く
5. 編集
6. 下記を追加
7. 保存

| タイプ | プロトコル | ポート範囲 | 送信元 |
| --- | --- | --- | --- |
| カスタムUDPルール | UDP | 137 | マイIP |
| カスタムUDPルール | UDP | 138 | マイIP |
| カスタムTCPルール | TCP | 139 | マイIP |
| カスタムTCPルール | TCP | 445 | マイIP |

マイIPではなく0.0.0.0/0にすればたぶんノーガードになる？

---

## sambaユーザーの追加

```
$ sudo smbpasswd -a {ユーザー名}
New SMB password:
Retype new SMB password:
Added user youkai-apache.
```

任意のパスワードを設定する

## sambaを起動

```
$ sudo /etc/init.d/smb start
```

もしくは

```
$ sudo service smb start
```

---

## エクスプローラーから接続

+ Windows
  + エクスプローラーを開く
  + アドレスバーに`\\IPアドレス`を入力
  + ダイアログに登録したユーザーとパスワードを入力

+ Mac( [ドキュメント](https://support.apple.com/ja-jp/HT204445) )
  + ファインダーを開く
  + 移動→サーバへ接続
  + `smb://{IPアドレス}`を入力


