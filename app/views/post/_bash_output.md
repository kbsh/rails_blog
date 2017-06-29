<%#
+++
date = "2016-12-21T15:57:51Z"
draft = false
title = "エラーや標準出力をファイルに書き出したい"
categories = ["bash"]
+++
%>

hoge.shを実行し、1(標準出力), 2(エラー出力)を共に/tmp/hoge.logに出力します。

`>`は上書き, `>>`は追記なので下記の例では追記します。

```
sh hoge.sh >> /tmp/hoge.log 2>&1
```
