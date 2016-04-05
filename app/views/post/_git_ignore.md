<%#
+++
date = "2016-02-19T15:17:51Z"
draft = false
title = "[git] 管理下から除外するパターン"
categories = ["git"]
+++
%>

### プロジェクト単位の除外

###### ignoreファイル

`.gitignore`

****************

### ローカルでの除外

###### ignoreファイル

`.git/info/exclude`

****************

### すでに管理済みのファイルをローカルで無視する

###### git上変更をうけつけない

リポジトリが優先される
`git update-index --assume-unchanged {path}`

###### git上変更を保つ

作業ツリーが優先される
`git update-index --skip-worktree {path}`

