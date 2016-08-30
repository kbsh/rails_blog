<%#
+++
date = "2016-08-29T16:54:51Z"
draft = false
title = "SSL備忘録"
categories = ["linux"]
+++
%>


CAはデフォルト。365日。

```
   74  cd /etc/nginx/
   75  ls
   76  cd ssl/
   77  ls
   78  vi nginx.
   79  ls
   80  mkdir ssl-key-20160829
   81  cd ssl-key-20160829/
   82  sudo sh -c "openssl genrsa 2048 > /etc/nginx/ssl/ssl-key-20160829/server.key"
   83  ll
   84  openssl rsa -text < server.key 
   85  sudo sh -c "openssl req -new -key /etc/nginx/ssl/ssl-key-20160829/server.key > /etc/nginx/ssl/ssl-key-20160829/server.csr"
   86  ll
   87  openssl x509 -req -signkey server.key < server.csr > server.crt
   88  ll
   89  vim /etc/nginx/conf.d/default.conf 
   90  service nginx configtest
   91  service nginx restart
```
