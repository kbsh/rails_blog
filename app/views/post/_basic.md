<%#
+++
date = "2016-08-29T19:54:51Z"
draft = false
title = "ubuntu, nginxでBASIC認証"
categories = ["linux", "ubuntu", "nginx"]
+++
%>

`apache2-utils`は`htpasswd`コマンドを使用するためです。

`htpasswd`のオプションは随時確認しましょう。

```
  185  apt-get install apache2-utils
  186  ll
  187  cd /etc/nginx/
  188  ls
  189  htpasswd -c -b .htpasswd [ユーザー名] [パスワード]
  190  ll
  191  cat .htpasswd 
  192  vi conf.d/default.conf 
+     location [保護したいパス] {
+         auth_basic "パスワードを入力してください";
+         auth_basic_user_file /etc/nginx/.htpasswd;
+     }
  193  service nginx configtest
  194  service nginx restart
```
