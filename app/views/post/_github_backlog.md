<%#
+++
date = "2016-08-08T12:35:51Z"
draft = false
title = "backlogとgithubの関連付け"
categories = ["github", "jenkins", "backlog"]
+++
%>

### 概要
チケットとPR（もしくはコミット）を紐付けたかったが、
githubで提供されているbacklogサービスだと使い勝手がよくなかったため自前で作成

| | backlogサービス | この記事のやつ |
| --- | --- | --- |
| 紐付け対象 | コミット | PR |
| トリガー| 対象コミットのpush | PRの作成、編集 |

※ backlogサービスでは、対象コミットを含むpush(PRのマージを含む)のたびに動いてしまう。
masterブランチのみの運用じゃないと2回以上紐付けられてしまう。

---

### 使い方
関連する課題のIDを確認する
![image](https://cloud.githubusercontent.com/assets/16536071/17468721/b39f9422-5d65-11e6-93bc-90ffa7244aec.png)

PRのタイトルかコメントに課題IDを貼り付ける（YOUKAI-45の部分です。両方に書く必要はありません）
![image](https://cloud.githubusercontent.com/assets/16536071/17468868/f2ccef4a-5d66-11e6-803e-2a225b75ca6d.png)

課題のページを見てみると、PRへのリンクが張られている。
![image](https://cloud.githubusercontent.com/assets/16536071/17468774/2ea7f8e4-5d66-11e6-9775-a6b9ba0e2e8e.png)

---

### jenkinsの設定

jenkinsの導入手順は省きます。

（github apiからの）パラメータの受け取り
![image](https://cloud.githubusercontent.com/assets/16536071/17468724/b9eb567c-5d65-11e6-9fdf-86ff0d5efec5.png)

（github apiからの）認証
githubの設定と一致させればなんでも良いです。
![image](https://cloud.githubusercontent.com/assets/16536071/17468727/bc4beeb8-5d65-11e6-9014-7c9cc1ab9a40.png)

スクリプトの実行
![image](https://cloud.githubusercontent.com/assets/16536071/17468729/beec5432-5d65-11e6-90fb-051aae6d6f6b.png)

---

### githubの設定

webhookの追加
![image](https://cloud.githubusercontent.com/assets/16536071/17468227/d67850ce-5d60-11e6-8148-362c33b8ebff.png)

payload url

`http://[jenkinsユーザー]:[jenkinsパスワード]@[IPアドレス]:8080/job/[jenkinsジョブ名]/buildWithParameters?token=edit_pr`

![image](https://cloud.githubusercontent.com/assets/16536071/17468273/5bf8af78-5d61-11e6-8fd4-1550c1c25372.png)

---

### サーバーに配置するファイル

tool/batch-youkai/comment_backlog.sh

```
#!/bin/bash
# 
# backlogの課題とgithubのPRを紐付ける
#

# PRの作成時、編集時のみ処理を行う
action=`cat payload.json | jq .action | sed -e s/\"//g`
if [ ${action} != 'opened' -a ${action} != 'edited' ]; then
  exit 1
fi

############# 変更が必要 ##################

# backlogのプロジェクトID
project_id="YOUKAI100"
# コメントをするユーザーのbacklogAPIトークン
api_key="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
# コメント本文
message="プルリクエストが関連付けられたにゃ！"

############# 変更が必要 ##################

# PRタイトル
title=`cat payload.json | jq .pull_request.title | sed -e s/\"//g`
# PRボディコメント
body=`cat payload.json | jq .pull_request.body | sed -e s/\"//g`
# PR番号
number=`cat payload.json | jq .number | sed -e s/\"//g`
# PRのURL
url=`cat payload.json | jq .pull_request.html_url | sed -e s/\"//g`
# リポジトリ名
repo=`cat payload.json | jq .repository.name | sed -e s/\"//g`

# 登録確認用ファイル
commented_list_file="/var/lib/jenkins/.${repo}_commented_list";

# PRタイトルかボディにbacklogの課題IDが記載されていれば配列に切り出す
title_issues=(`echo ${title} | grep -o "$project_id-[0-9]\+"`)
body_issues=(`echo ${body} | grep -o "$project_id-[0-9]\+"`)

# 切り出した課題ID配列の結合
issues=(${title_issues[*]} ${body_issues[*]})

for issue in ${issues[@]}; do
  # 登録済みか
  php /data/youkai-dev/tool/batch-youkai/comment_issues_list.php $number $issue $commented_list_file
  if [ $? -eq 2 ]; then
    # backlogの課題にコメントする
    comment="【[$title]($url)】$message"
    curl -XPOST https://xxxxx.backlog.jp/api/v2/issues/$issue/comments?apiKey=$api_key -d content=$comment
  fi
done
```

/data/youkai-dev/tool/batch-youkai/comment_issues_list.php

jsonファイルの書き換えがbashでうまくできなかったためphpファイルに分けました･･･。

```
<?php
/**
 * PR番号に対し、課題番号が登録済みか判定する
 * 登録とは、ローカルファイルへの番号の保存を行うこと
 */

$number              = $argv[1];  // github  PR番号
$issue               = $argv[2];  // backlog 課題番号
$commented_list_file = $argv[3];  // 登録済み課題番号を管理するファイル

$key = "pr$number";               // jsonのPR番号キー。数字だとjqコマンドで索引できないため
$exit_status = 0;                 // 正常終了ステータス
$added_exit_status = 2;           // 登録時の終了ステータス

// パラメータ不足
if (empty($number) || empty($issue) || empty($commented_list_file)) {
  exit;
}

// 登録済み課題一覧を取得
$json_commented_list = json_decode(file_get_contents($commented_list_file));

// 対象のPR番号の登録済み課題の存在確認
if (isset($json_commented_list->$key)) {
  // 対象の課題番号が登録済みか
  $commented_issues = $json_commented_list->$key;
  foreach ($commented_issues as $commented_issue) {
    if ($commented_issue == $issue) {
      exit;
    }
  }

  // 未登録の場合は登録フラグをたてる
  $commented_issues[] = $issue;
  $exit_status = $added_exit_status;
} else {
  // 未登録の場合は登録フラグをたてる
  $commented_issues = array($issue);
  $exit_status = $added_exit_status;
}

// 登録フラグがたっている場合、登録処理を行う
if ($exit_status == $added_exit_status) {
  $json_commented_list->$key = $commented_issues;
  file_put_contents($commented_list_file, json_encode($json_commented_list));
}

// ステータスを返却する
exit($exit_status);
```

----

### その他

1. githubapi用にサーバーのポートをあけておくこと(TCP 8080 [IP](https://api.github.com/meta))
1. 必要があればjenkinsにルート権もたせておくこと(visudu)

