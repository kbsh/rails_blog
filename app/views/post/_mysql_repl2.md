<%#
+++
date = "2017-05-02T16:54:51Z"
draft = false
title = "[mysql]レプリケーション構成での注意点"
categories = ["mysql"]
+++
%>

master-slave構成でやっちゃいけないこと一覧


- スレーブに更新
  - 非決定性関数の実行
  - sysdate（スレーブでも現在日付を取得するsqlが走るのでマスターとずれる）
    - nowはTIMESTAMP変数を返すだけなのでOK
  - ユニークじゃないキーでupdate order by limit
