<%#
+++
date = "2015-11-04T17:29:51Z"
draft = false
title = "php7をインストール"
categories = ["ubuntu","php"]
+++
%>


先日正式に発表されたphp7。<br>
さっそくなのでいれてみようとおもう。<br>

ただ、<br>
apt-cache searchでみつからなかったので調べたよ。

```
// rootになる
$ sudo su -

// リポジトリに追加
$ echo "deb http://repos.zend.com/zend-server/early-access/php7/repos ubuntu/" >> /etc/apt/sources.list

// リポジトリ更新
$ apt-get update

// 確認
$ apt-cache search php7

php7-beta1 - PHP7 Beta1 build compiled by Zend Technologies
php7-nightly - PHP7 nightly build compiled by Zend Technologies


// pathを通しておく
$ vi .bash_profile
+ export PATH=/usr/local/php7/bin:$PATH

// 再読み込み
$ source .bash_profile

// バージョン確認
$ php -v

PHP 7.0.1-dev (cli) (built: Nov  3 2015 20:10:19) ( NTS )
Copyright (c) 1997-2015 The PHP Group
Zend Engine v3.0.0-dev, Copyright (c) 1998-2015 Zend Technologies
```

