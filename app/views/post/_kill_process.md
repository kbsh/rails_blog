<%#
+++
date = "2016-06-03T19:24:51Z"
draft = false
title = "複数プロセスを検索してkill!"
categories = ["linux", "bash"]
+++
%>

ターミナルによってssh-agentプロセスが遮断されずに行き続け、大量に残ってしまうことがある。<br>
自分が気をつけていてもメンバーが・・・ということも。

```
kill `ps -ef | grep {usernameなどの条件} | grep ssh-agent | awk '{print $2;}'`
```

| こまんど | せつめい |
| --- | --- |
| ps -ef | プロセス一覧を取得 |
| grep | 条件を指定して絞りこみ |
| aux | スペース区切りで行を分割。2ブロック目(プロセスID)を取得 |
