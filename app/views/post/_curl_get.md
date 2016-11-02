<%#
+++
date = "2016-10-05T17:52:51Z"
draft = false
title = "curlコマンドのGETパラメータが複数(2つ以上)渡せない問題"
categories = ["linux"]
+++
%>

```
$ curl -s https://hogehoge/hoge?param1=test1&param2=test2&param3=test3
```

とすると、param1しかパラメータとしてわたされない。

原因は`&`がbashの処理連結とみなされるため。

つまり、

`curl -s https://hogehoge/hoge?param1=test1`と`param2=test2`と`param3=test3`が別処理として実行されている。

```
$ curl -s https://hogehoge/hoge?param1=test1&param2=test2&param3=test3
$ echo $param2
test2
```

---

対策として、`""`でURLを囲ってあげましょう

```
$ curl -s "https://hogehoge/hoge?param1=test1&param2=test2&param3=test3"
```
