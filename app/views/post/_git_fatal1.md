<%#
+++
date = "2015-08-26T10:14:51Z"
draft = false
title = "git エラー `fatal: index file smaller than expected`"
categories = ["git"]
+++
%>


チーム内でgit のブランチ切り替え、cloneができないという相談がありました。<br>

```
$ git status
# On branch feature/post/57003
# Untracked files:
#   (use "git add <file>..." to include in what will be committed)
```
`git status`は正常に返ってくる模様。

```
$ git checkout branch
fatal: index file smaller than expected
```
ブランチ切り替えが確かにできない。<br>
gitのindexファイルが期待値より小さい？？<br><br>


調べてみると、二つの見解が。

```
1. サーバーの容量不足
2. .git/indexファイルが破損
```

私の場合は`1. サーバーの容量不足`で解決しました。

`2. .git/indexファイルが破損`の場合は下記コマンドを叩きましょう。

```
# .git/indexファイルのバックアップをとりましょう。
$ mv .git/index .git/index.backup

# .git/indexファイルを復元してあげましょう
$ git reset HEAD
``` 

