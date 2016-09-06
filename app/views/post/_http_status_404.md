<%#
+++
date = "2016-09-02T17:07:51Z"
draft = false
title = "403を404に変える"
categories = ["apache", "nginx", "php"]
+++
%>

### やりたいこと

403を404にみせる。

403が表示されてしまうとディレクトリの存在が漏洩するため。

-

404ページを作成する。既にあるなら、1行目を追加する

HTTPステータスを書き換えている。

```
vi /hoge/404.php

<?php header('HTTP/1.1 404 Not Found') ?>
<!DOCTYPE html>
<html>
<head><title>404 Not Found</title></head>
<body>
<h1>Not Found</h1>
The requested URL was not found on this server.
</body>
</html>
```

403, 404を404.phpにとばす。

```
vi /etc/httpd/conf/httpd.conf

ErrorDocument 403 /404.php
ErrorDocument 404 /404.php
```

