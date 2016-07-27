<%#
+++
date = "2016-07-22T17:58:51Z"
draft = false
title = "EC2インスタンスを停止した際の再設定項目"
categories = ["aws"]
+++
%>

## 概要

インスタンスを停止すると・・・

IPアドレスが消えます。

再度起動すると新しいIPアドレスが割り振られます。

サーバーが物理的?に死んだ時とか明らかにサーバー側の不具合でない限り押さないことをお勧めします。

---

## 起動する

EC2より起動してください。

---

## Elastic IPを取得

1. Elastic IPに移動
2. アクション
3. アドレスの関連付け
4. インスタンスを選択
5. 関連付ける

新しいElastic IPをコピーしておきましょう。

---

## DNSの設定

ここではRoute 53の設定を説明しますが、他サービスを利用しているばあいはそちらで設定してください。

1. Route53に移動
2. Hosted zonesに移動
3. 対象のドメインを選択
4. Go to Record Sets( もしくはDomain Nameのリンクを押す )
5. Type `A`のレコードを選択
6. Valueを新しいElastic IPに書き換える


---

## webサーバーなどの立ち上げ

1. 新しいIPアドレスでサーバーに接続
2. 各サービスの起動

```
$ sudo service nginx start
$ sudo service memcached start
```

---

## IP制限しているサーバーの再設定

該当のサーバーに対し、iptablesなどによるIP制限をしていないか確認し適宜設定

---

## 別途設定項目

+ .ssh/config( mac / linux )
+ ローカルのssh接続ショートカット( windows )
