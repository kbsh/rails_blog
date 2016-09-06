<%#
+++
date = "2016-09-01T15:23:51Z"
draft = false
title = "アプリケーションからTreasureDataにレコードを挿入するまで"
categories = ["linux", "treasuredata", "fluentd"]
+++
%>

公式のドキュメントは[こちら](https://docs.treasuredata.com/articles/php#step-2-modifying-etctd-agenttd-agentconf)です。


### 前提

CentOs, PHPでの作業です。

別OSの場合インストールパッケージの違いにご注意ください。

別言語の場合はfluentdパッケージが別のものとなります。


---

### 通しのコマンド

```
su
curl -L http://toolbelt.treasuredata.com/sh/install-redhat-td-agent2.sh | sh
vi /etc/td-agent/td-agent.conf
-   apikey YOUR_API_KEY
+   apikey hoge

- #<source>
-   #type unix
- #</source>
+ <source>
+   type unix
+   path /var/run/td-agent/td-agent.sock
+ </source>
/etc/init.d/td-agent configtest
/etc/init.d/td-agent restart
cd path/to
git submodule add git@github.com:fluent/fluent-logger-php.git
vi fluent-logger-php/composer.json
-         "php": ">=5.3.0"
+         "php": ">=5.3.0",
+         "fluent/logger": "v1.0.0"
curl -sS https://getcomposer.org/installer | php
php composer.phar install
```

---

### 解説


###### td-agentのインストール

```
curl -L http://toolbelt.treasuredata.com/sh/install-redhat-td-agent2.sh | sh
```

###### td-agent.confの書き換え

`YOUR_API_KEY`はTreasureDataの[プロフィール](https://console.treasuredata.com/users/current)にて確認ください。

プロジェクトに参加している場合は共通アカウントの発行をお勧めします。


```
vi /etc/td-agent/td-agent.conf
-   apikey YOUR_API_KEY
+   apikey hoge

- #<source>
-   #type unix
- #</source>
+ <source>
+   type unix
+   path /var/run/td-agent/td-agent.sock
+ </source>
```

###### td-agentの立ち上げ

```
/etc/init.d/td-agent configtest
/etc/init.d/td-agent restart
```

`/var/run/td-agent`に`td-agent.pid` `td-agent.sock`ができていればOK

###### ライブラリを配置したいパスへ移動

fluent-logger-phpパッケージを配置するパスへ移動します。

```
cd path/to
```

###### fluent-logger-phpパッケージのインストール

私の場合、forkしたリポジトリをsubmoduleに追加しました。

```
git submodule add git@github.com:fluent/fluent-logger-php.git
もしくは
git clone git@github.com:fluent/fluent-logger-php.git
もしくは直で配置
```

###### composer.jsonの用意

fluent-logger-phpにふくまれるcomposerの設定ファイルを書き換えます。

```
vi fluent-logger-php/composer.json
-         "php": ">=5.3.0"
+         "php": ">=5.3.0",
+         "fluent/logger": "v1.0.0"

```

もしくは、全削除して下記のみ設定でもよいです。

```
{
  "require": {
    "fluent/logger": "v1.0.0"
  }
}
```

###### composerのインストール

```
curl -sS https://getcomposer.org/installer | php
php composer.phar install
```

これにて準備完了です。


---


### アプリケーションへの組み込み

TDへの追加を行うトレイト。


td-agent.confの設定がデフォルトであれば、

テーブルは自動でcreateされます。

LoggerTd.php

```
<?php
require_once 'fluent-logger-php/vendor/autoload.php';
use Fluent\Logger\FluentLogger;
/**
 * Treasure Data関連
 */
trait LoggerTd {
    protected $_TAG_SUFFIX = "td";
    protected $_DB_NAME    = "hoge";
    protected $_SOCK_PATH  = "unix:///var/run/td-agent/td-agent.sock";
    /**
     * TDに書き込みを行う
     *
     * @param string $table_name
     * @param array  $params     挿入データ array([カラム名]=>[データ])
     */
    protected function insertTd ($table_name, $params)// {{{
    {
        if (!$this->isEnabled()) {
            return;
        }
        $logger = new FluentLogger($this->_SOCK_PATH);
        $logger->post(
            $this->_TAG_SUFFIX . "." . $this->_DB_NAME . "." . $table_name,
            $params
        );
    }// }}}
    /**
     * TDを利用可能か
     *
     * @return bool
     */
    private function isEnabled ()// {{{
    {
        // ここは何らかの方法で開発環境か本番環境かを判定しましょう。
        $env = "production"
        if (isset($env) && $env == 'production') {
            return true;
        }
        return false;
    }// }}}
}
/**
 * vim: set foldmethod=marker :
 */
```

トレイトの呼び出しによるTDへのデータ挿入

```
+ require_once 'traits/LoggerTd.php';

+     use LoggerTd;

+         $this->insertTd(
+             'test-table',
+             array(
+                 'column1' => 1,
+                 'column2' => 22,
+                 'column3' => "test1",
+                 'column4' => "test2",
+             )
+         );
```
