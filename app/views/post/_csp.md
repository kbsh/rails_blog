<%#
+++
date = "2016-09-02T15:57:51Z"
draft = false
title = "Content-Security-Policyの設定方法"
categories = ["apache", "nginx"]
+++
%>

### やりたいこと

HTTPヘッダに`Content-Security-Policy`をつけてXSSやらの攻撃を防ぎたい

---

### ポリシーのパターン

[参照](https://developer.mozilla.org/ja/docs/Web/Security/CSP/CSP_policy_directives)

---

### apache

バーチャルホストを設定しているconfもしくは`.htaccess`に足す。

```
vi /etc/httpd/conf/virtualHost/httpd.conf

Header set Content-Security-Policy "default-src 'self';"
```

---


### nginx

server {}内にかく。

```
add_header Content-Security-Policy "default-src 'self';";
```
