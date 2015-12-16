<%#
+++
date = "2015-07-01T14:30:51Z"
draft = false
title = "まっさらなubuntuサーバーにnginxでHUGOブログを立ち上げる"
categories = ["blog","ubuntu","aws","nginx"]
+++
%>


備忘録のためにブログをはじめてみたいという理由ではじめました。
とりあえずawsで借りたubuntuサーバーで立ち上げられたのでそこまでのメモです。

まずは記事からHTMLを生成してくれるソフトウェアの選定からです。
素直にシェアから考えればwordpressですがそれではつまらないですね。
というわけで<a href='http://gohugo.io' target="_blank">HUGO</a>です。
<br>

HUGOを選んだ理由は

```
1. markdownが使える。
2. なし
```

以上です。調べても記事が少なく、やりがいがありそうだなーという印象です。
<br>

実際に立ち上げてみての感想は

```
1. フレームワークがしっかりしているのでメンテナンスが楽
2. かといってがっちり決められているわけではなく、自由にいじれる
```

と言った感じです。
他のブログソフトを使ったことが無いので比較はできませんけどね！！
<br><br>

さて本題。このHUGO、なにでインストールできるんだ？

```
$ go get -v github.com/spf13/hugo
$ brew install hugo
```

go,brewでインストールできるようです。
今回はbrewでインストールしようと思います。

```
6. hugoで記事作成テスト
↑
5. nginxをインストールしてhugoを起動
↑
4. hugoの設定
↑
3. brewでhugoインストール
↑
2. rubyでbrewインストール
↑
1. apt-get（ubuntu標準）でrubyインストール
```

といった作業の流れになります。
<br><br>
***

# 1.rubyをインストールします。
rubyのバージョンは<a href="https://www.ruby-lang.org/ja/downloads/" target="_blank">こちら</a>で最新がいくつかを確認するとよいです。

```
$ sudo add-apt-repository -y ppa:brightbox/ruby-ng
$ sudo apt-get update
$ sudo apt-get -y install ruby2.2
```
<br>
***


# 2.brewをインストールします。
ubuntuなので<a href='http://brew.sh/linuxbrew/' target="_blank">Linuxbrew</a>です。brewとは別のようです。

```
$ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/linuxbrew/go/install)"

Warning: /home/ubuntu/.linuxbrew/bin is not in your PATH.
```
なんかワーニングでました。私だけ？（；＿；）
PATHが通ってないとのことなので通しときましょう。
これを.bashrcに追加しておきます。

```
export PATH="$HOME/.linuxbrew/bin:$PATH"
export LD_LIBRARY_PATH="$HOME/.linuxbrew/lib:$LD_LIBRARY_PATH"
```

確認してみます・・。

```
$ brew doctor
Your system is ready to brew.
```
is ready!
大丈夫そうなので進みます。

ubuntuにはこれも必要とのことなのでLinuxbrew dependenciesもいれておきます。

```
$ sudo apt-get install build-essential curl git m4 ruby texinfo libbz2-dev libcurl4-openssl-dev libexpat-dev libncurses-dev zlib1g-dev
```
<br>
***


# 3.HUGOをインストールします。
早速コマンドを打ちます。

```
$ brew install hugo
==> Installing dependencies for hugo: mercurial, go
==> Installing hugo dependency: mercurial
==> Downloading https://mercurial.selenic.com/release/mercurial-3.4.1.tar.gz

################# 100.0%

==> make PREFIX=/home/ubuntu/.linuxbrew/Cellar/mercurial/3.4.1 install-bin
#include 
^
compilation terminated.
error: command '/usr/bin/gcc-4.8' failed with exit status 1
make: *** [build] Error 1

READ THIS: https://github.com/Homebrew/linuxbrew/blob/master/share/doc/homebrew/Troubleshooting.md#troubleshooting
```
なんかまたエラーでた・・・orz

調べてみると、
gcc-4.8、これ、pythonと関連するものらしく、
pythonをいれれば解決されそうな雰囲気・・。

```
$ apt-get install python-dev
```

pythonいれたところで、再度HUGOをいれてみる・・。

```
$ brew install hugo
```

今度はすんなりいった模様！
<br><br>
***


# 4. HUGOの初期設定
HUGOのドキュメント<a href='http://gohugo.io/overview/quickstart/' target="_blank">こちら</a>です。

初期設定では下記３項目を行い、以降はルーチンで記事作成とアップロードを行います。
1. コンテンツ（site）の作成
2. デザイン（theme）の選択
3. 設定ファイル(conf)の編集

まずはコンテンツの作成をします
hogeという名前で例示します。

```
$ hugo new site hoge
```

下記のようなファイル構成になっているとおもいます。

```
  ▸ archetypes/
  ▸ content/
  ▸ layouts/
  ▸ static/
    config.toml
```

content以下にmarkdown方式で記事を書いていきます
layouts以下が実際に参照するディレクトリです。
config.tomlには定数を設定できます。

つぎにデザインを選定します。
全パターンのテーマを落とし、あとで不要なテーマは削除しましょう。
<a href='http://themes.gohugo.io' target="_blank">プレビューサイト</a>を開発中とのことなので、オープンしていたら先にみてしまってもよいでしょう。

```
$ cd hoge
$ git clone --recursive https://github.com/spf13/hugoThemes themes
```

```
  ▸ archetypes/
  ▸ content/
  ▸ layouts/
  ▸ static/
  ▸ themes/
    config.toml
```

themes内のディレクトリ名がテーマ名と一致しているので、気に入ったものを当てはめていきます。

たとえば、hydeを適用するとこちら

```
$ hugo server --theme=hyde --buildDrafts --watch 
```

実行コマンドによりpublic以下にディレクトリができている。
これをlayoutsに移動して完了（なぜpublicではなくlayoutsを参照させるかはよく調べていない）

```
$ rm -rf layouts
$ mv public/ layouts
```

これでwebにアクセスすればデザインが反映されたブログが表示されているはず。
だが、ローカルで環境をたてているならhttp://localhost:1313でいいとして、
今回はubuntuサーバーに環境をつくっている。
apacheかなにかでwebサーバ構築しなければ・・。
<br><br>
***


# 5.nginxのインストール
タイトルにも書いた通り、apacheではなくnginxを使います。エンジンエックスと読むらしいです。
読み方がかっこいいから選びました（あほかと）

```
$ sudo apt-get install aptitude
$ sudo aptitude update
$ sudo aptitude search nginx
```

nginxのパッケージの種類を調べて見ると、なにやらいろいろある。バージョンとかは無い模様。
まとめると下記の４つらしい。
nginxがデフォルト。nginx-fullはnginxのミラー。
nginx-extrasはなにやら機能が多いよう。なにが多いのかはヨクワカラナイ。
nginx-lightは逆に機能が最小限とのこと。

```
nginx
nginx-extras
nginx-full
nginx-light
```

とりあえず全部入りのextraをいれてみる

```
$ sudo aptitude install nginx-extras
```

とりあえずnginxを起動する

```
$ sudo /etc/init.d/nginx start
```

下のようなディレクトリ構造になるらしい。

```
# startとかstopとかrestartする
/etc/init.d/nginx start

# 最初に読み込まれるconf。この中で、include /etc/nginx/conf.d/*.confとかやる
/etc/nginx/nginx.conf

# 各conf
/etc/nginx/conf.d/*.conf
```

と、おもいきや、confがいろいろおかしい！！
調べると、/etc/nginx/conf.d/default.confやらがあるらしいのだが、ない。
独自にserverのアクセス設定などするが、動かない！！（なにか足りて無かったのかも）

extraがあかんのか・・・？とおもい、通常のnginxを入れ直すことに

```
$ sudo aptitude remove nginx-common
```

これで関連のパッケージを削除してくれた模様。
一応パッケージ更新しつつ再インストールしてみる。

```
$ sudo aptitude update
$ sudo aptitude upgrade
$ sudo aptitude install nginx 
# ついでに起動
$ sudo /etc/init.d/nginx start
```

今度は情報通りにconfが配置された模様。
extraがあかんかったのか・・・？

/etc/nginx/conf.d/default.confを書き換える。

<font color='red'>
2015/11/17 追記<br>
ruby on railsを入れる際に<br>
railsをhttpサーバで動作させるモジュールとして`passenger`を利用することにしたのですが<br>
nginx-extrasじゃないとダメでした。

くわしくは<a href='https://docs.google.com/spreadsheets/d/1zvCb0xuI1gafUFvtr_RhYS4E8bnlk2sQzwjor4MrXEs/edit#gid=0'>こちら</a>
</font>

```
`
`
`
# 任意なものに
server_name  hugo.com;
`
`
# /home/ubuntuまでは任意の位置に。
# layouts直下にすること！
root   /home/ubuntu/hoge/layouts;
`
`
`
# ログを吐く場所。デフォルトでもよい。
# 変更するならディレクトリをつくっておくこと
access_log  /var/log/nginx/hoge/access.log   main;
error_log   /var/log/nginx/hoge/error.log;
```

書き換えたらnginxを再起動

```
$ sudo /etc/init.d/nginx restart
```

これで借りているドメインにアクセスして確認すること。
デザインが気に入らなければ下記手順を繰り返すこと

```
# デザインを適用
$ hugo server --theme=hyde --buildDrafts --watch 
# publicからlayoutsに移動
$ rm -rf layouts
$ mv public/ layouts
```
<br><br>
***

# 6.HUGOの記事作成

コンテンツのルートで、記事作成コマンドをうつ

```
$ hugo new test.md
```

下記フォーマットで作られるので本文部分から記事を書いていく。titleが記事のタイトルとなる。

```
 +++
 date = "2015-06-26T04:12:51Z"
 draft = true
 title = "test"

 +++

 ここから本文
```

以降はhugo newコマンドを打たなくてもcpやviでフォーマットをコピーしてしまえば問題無い。

書いた記事をデプロイする。

```
$ hugo server --theme=hyde --buildDrafts --watch 
# publicからlayoutsに移動
$ rm -rf layouts
$ mv public/ layouts
```

デザイン適用時とおなじコマンドです。
こちらエイリアスに登録したりshellをつくってしまっても良いですね。
<br>

以上です。
