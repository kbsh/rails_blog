<%#
+++
date = "2017-04-06T16:54:51Z"
draft = false
title = "ローカルブランチをリモートブランチの状態に初期化"
categories = ["git"]
+++
%>

`git pull -f`みたいなものがあったらな・・というときのために


### 簡単なやりかた

```
git fetch
# リモートの状態にハードリセット
git reset --hard origin/[ブランチ]
```

### 覚えられない、reset怖いってとき

```
git fetch
# 該当ブランチを削除
git checkout [適当なブランチ]
git delete -D [ブランチ]
# リモートから再取得
git checkout [ブランチ]
```
