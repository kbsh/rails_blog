<%#
+++
date = "2016-09-02T16:03:51Z"
draft = false
title = "X-XSS-Protectionの設定方法"
categories = ["apache", "nginx"]
+++
%>

### やりたいこと

HTTPヘッダに`X-XSS-Protection`をつけてXSSやらの攻撃を防ぎたい

---

### apache

バーチャルホストを設定しているconfもしくは`.htaccess`に足す。

```
vi /etc/httpd/conf/virtualHost/httpd.conf

Header set X-XSS-Protection "1; mode=block"
```

---


### nginx

server {}内にかく。

```
add_header X-XSS-Protection "1; mode=block";
```
