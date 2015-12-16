<%#
+++
date = "2015-09-24T11:50:51Z"
draft = false
title = "[git] historyに残したくない修正コミットを統合する"
categories = ["git"]
+++
%>


コミット後に誤字に気づき、修正をしたけど、</br>
このコミットをログに残したくない・・・<br>

ということはよくあると思います。
そんなときは`git rebase -i [commit]`コマンドを使いましょう。

```
# メインのコミット -aはaddを一緒にやる
$ git comimt -am 'fix1'

# 誤字の修正
$ git commit -am 'fix2'

# HEAD（最新コミット）から2件分のコミットを統合する
$ git rebase -i HEAD~2

pick aa5b782 fix1
pick 146a328 fix2 # ← pickをfixupに書き換えよう！
.
.
.
```

これでコミットが`fix1`にまとめられます。
統合したいコミットのメッセージを残したい場合は`fixup`ではなく`asuash`に変えるといいらしい。

