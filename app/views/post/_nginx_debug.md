<%#
+++
date = "2015-09-16T16:54:51Z"
draft = false
title = "[nginx]confファイル内でデバッグ"
categories = ["nginx"]
+++
%>


```トピック
-何がしたいか
-ログフォーマットを作る
-出力するログファイルを設定する
```

***

### 何がしたいか
nginxの設定ファイルは変数なりifなりを使える。<br>
そこで、変数の値や条件分岐が正しく動いているかを調べるためにデバッグしたくなる。

***

### ログフォーマットを作る
```
log_format debug_val_format $hoge;
```

$hogeはなんでもいいよ。

***

### 出力するログファイルを設定する
```
access_log  /var/log/nginx/access.log   debug_val_format;
```


***

### ログファイルを監視
```
$ tail -100 -f /var/log/nginx/access.log
```

アクセスすれば$hogeが出力される
