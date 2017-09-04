<%#
+++
date = "2015-09-16T14:49:51Z"
draft = false
title = "[AWS][route53][nginx]サブドメインの作成"
categories = ["aws","nginx"]
+++
%>


```トピック
-何がしたいか
-awsの設定
-nginxの設定
```

***

### 何がしたいか
ぼちぼちwebコンテンツ増やしたくなってきたが、新しいドメインつくるのもなぁ・・

ということで、既存のルートドメイン`sk-create.biz`をサブドメイン（`xxx.sk-create.biz`）として流用します

前提として、わたしの環境

| これは | これ使ってるよ |
| --- | --- |
| サーバー | EC2 |
| ドメイン | Route53 |
| webサーバー | nginx |

ドメインもawsで借りたものです。<br>
ドメインをどこで借りたかわからなくなったおばかさん（私です。）は<br>
[Whois](http://reports.internic.net/cgi/whois?whois_nic=sk-create.biz&type=domain)で探してください。<br>
Registrant xxxの辺りが貸主情報です。

同じ環境でルートドメインでの設定が終わっている前提で書きます・・。

***

### awsの設定
awsのsaasの一つで、ドメインとホストゾーンを管理しているものが、`Route53`です。

```
1. Hosted Zonesをクリック
2. 設定したいルートドメインをクリック
```

ここで、下記の３つのレコードがあることを確認します

| Type | 説明 |
| --- | --- |
| A | アドレス。ホストとIPアドレスを紐づける。 |
| NS | ネームサーバ。借りているドメインと紐づく。 |
| SOA | 触らないでOK。 |

今回は使わないけど他にこんなレコードがある

| Type | 説明 |
| --- | --- |
| MX | メールサーバ。 |
| CNAME | 代替ドメイン。独自ドメインを紐づける。Aレコードのaliasでも同じようにできるとか。 |

CNAMEをつかってなんたらするのかと思いすごい調べたのですが、どうやら違った模様。<br>
ここでやることは、`サブドメインのAレコードを追加するだけ`。

```
1. Create Recode Setをクリック
2. Nameにサブドメインを入力（xxx.sk-create.bizのxxx）
3. TypeをAで設定
4. ValueはルートドメインのAレコードのValue（EC2のパブリックIP）をコピペ
5. 他はデフォルトのままでcreateをクリック
```

awsの設定はこれだけ。<br>
xxx.sk-create.bizにアクセスすると、`403`エラーになったら成功 ∩^ω^∩<br>
awsの設定反映に数分かかります。ゾーンの追加をしなければ課金額はかわらない（と思う）ので気長に待ちましょう。

***

### nginxの設定
続いてnginxの設定をします。<br>
403エラーがでているならconfまではたどり着いているはず。

```
# confファイル書き換え
$ sudo vi /etc/nginx/conf.d/default.conf
```

```
# $http_host ホスト名ごとにディレクトリ名をセット(root, logで使用）
map $http_host $dir {
    sk-create.biz          blog;
    xxx.sk-create.biz      xxx;
    default                blog;
}

server {
    listen       80;
    server_name  sk-create.biz;

    location / {
        root   /hoge/$dir/public/;
        index index.html;
        access_log  /var/log/nginx/$dir/access.log   main;
        error_log   /var/log/nginx/$dir/error.log;
    }

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
}
```

ディレクトリ構成は人それぞれでしょうし、<br>
confの設定は参考程度にどうぞ。
