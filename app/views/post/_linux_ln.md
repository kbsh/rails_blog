<%#
+++
date = "2016-7-19T18:23:51Z"
draft = false
title = "DocumentRootにシンボリックリンクを設定した際に動かないとき"
categories = ["linux","nginx","apache"]
+++
%>


### 原因1 リンク先のパーミッション


```
$ ln -s /home/user1/www {張り先の絶対パス}
```

たとえば上記のようにシンボリックリンクを張った場合

`/home/user1`にapache(nginx)のアクセス権がないことが考えられる

そのため、権限をつけてあげる

```
$ sudo chmod 755 /home/user1
```


---

### 原因2 リンク元と先の所有権

所有権が一致していないとダメらしい。

```
$ chown -h apache:apache {シンボリックリンク張り先のパス}
```

`hオプション`は、シンボリックリンクにも有効になるオプション。

パスは早退パスでOK

**パスの最後に`/`をつけてはならない！！！**

---

### 原因3 ホームディレクトリが読める設定になっていない

```
$ sudo su
$ getsebool -a | grep  "httpd_enable_homedirs\|httpd_read_user_content"
httpd_enable_homedirs --> off
httpd_read_user_content --> off
```

これを`on`にする

```
setsebool -P httpd_enable_homedirs on
setsebool -P httpd_read_user_content on
```
