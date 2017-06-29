<%#
+++
date = "2015-09-24T11:50:51Z"
draft = false
title = "[git rebase] historyに残したくない修正コミットを統合する"
categories = ["git"]
+++
%>


コミット後に誤字に気づき、修正をしたけど、</br>
このコミットをログに残したくない・・・<br>

ということはよくあると思います。
そんなときは`git rebase -i [commit]`コマンドを使いましょう。

```
# メインのコミット -aはaddを一緒にやる
$ git commit -am 'fix1'

# 誤字の修正
$ git commit -am 'fix2'

# HEAD（最新コミット）から2件分のコミットを操作する
$ git rebase -i HEAD~2

pick aa5b782 fix1
pick 146a328 fix2 # ← pickをfixup/squash/sのいずれかに書き換えよう！
.
.
.
```

これでコミットが`fix1`にまとめられます。

コマンド | 効果
--- | ---
fixup | 一つ上のコミットに統合する
squash | fixupした上で、コメントの変更を行うことができる

---

個人的にはsquashのほうが、コメント編集時に統合するコミット群を確認できるので安心
