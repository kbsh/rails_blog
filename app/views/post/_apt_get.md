<%#
+++
date = "2015-09-29T12:26:51Z"
draft = false
title = "[debian][ubuntu]apt-getコマンド一覧。パッケージ操作。"
categories = ["ubuntu"]
+++
%>


### apt-getコマンド一覧
debian系で使うよね

---

###### 取得、問い合わせ系

| スイッチ | 説明 |
| --- | --- |
| apt-cache gencaches | インストール済パッケージ情報の更新。 |
| apt-cache show [package] | パッケージ情報の表示。 |
| apt-cache showpkg [package] | パッケージの詳細情報を表示。 |
| apt-cache depends [package] | パッケージの依存情報の表示。 |
| apt-cache search [keyword] | パッケージの検索。 |
| dpkg -l [package] | インストールされてるパッケージの一覧。 |
| dpkg -L | インストールした時のファイルの一覧。 |

<br>

###### インストール、更新系

| スイッチ | 説明 |
| --- | --- |
| apt-get update | ライブラリの更新。更新先は/etc/apt/sources.list。 |
| apt-get install [package] | パッケージのインストール。 |
| apt-get upgrade | インストールされてるパッケージの更新。新規インストールや削除が不要なもののみ。 |
| apt-get dist-upgrade | インストールされてるパッケージの更新。新規インストールや削除の必要かを問わず。/ディストリビューションの更新に使用。 |

<br>

###### 削除系

| スイッチ | 説明 |
| --- | --- |
| apt-get remove [package] | パッケージの削除。 |
| apt-get autoremove | 使ってないパッケージの削除。 |
| apt-get purge [package] | パッケージの削除（設定ファイルも）。 |
| apt-get autoclean | 使ってないパッケージのアーカイブファイルの削除。 |
| apt-get clean | アーカイブファイルを全て削除。 |

