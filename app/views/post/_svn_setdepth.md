<%#
+++
date = "2015-07-30T11:53:51Z"
draft = false
title = "svnリポジトリをチェックアウトする際、特定のディレクトリを除外する"
categories = ["svn"]
+++
%>


SVNリポジトリをチェックアウトする際

+ あるディレクトリが大きすぎるからcheck outを分けてやりたい
+ あるディレクトリは除外したい

といったことはよくあるはず。<br>

```
└─hoge
    └a // 普通
     ─b // 普通
     ─c // 大きい。分けてチェックアウトしたい
     ─d // 大きい。分けてチェックアウトしたい
     ─e // 除外したい
```

hogeをチェックアウトしたいが、<br>
`cとdがでかいから分けてやりたい。`<br>
`eは管理から除外したい。`<br>
といった時です。

ただ、分けてcheck out すると`svn up hoge`と上からアップデートできないといった問題が・・。<br>
そんなときに使うのが下記のコマンド。<br>


```
// immediateは直下の子階層のみチェックアウト
$ svn checkout hoge --depth immediate

$ cd hoge

// infinityは再帰的。全階層をチェックアウト
$ svn checkout a/ --set-depth infinity 
$ svn checkout b/ --set-depth infinity 
$ svn checkout c/ --set-depth infinity 
$ svn checkout d/ --set-depth infinity 

// eはチェックアウトしない
```

これで`svn up hoge`としてもa, b, c, dがアップデートされ、eは無視されます。<br>
gitがはやる前に知っておきたかった・・・。

