<%#
+++
date = "2016-06-03T19:29:51Z"
draft = false
title = "サーバーの容量をしらべる"
categories = ["linux", "bash"]
+++
%>

###### サーバーの容量をしらべる

```
$ df -h                                                                                                                                                                     
Filesystem      Size  Used Avail Use% Mounted on
xxxxx       29G   15G   13G  54% /
xxxxx      1.9G     0  1.9G   0% /dev
xxxxx      194M   87M   97M  48% /boot
xxxxx       30G   25G  3.3G  89% /mnt/01
xxxxx       50G   10G   37G  22% /mnt/02
```

**************


###### ディレクトリごとの使用容量

--max-depth=1で直下のみにする
引数で対象ディレクトリを指定

```
$du -h --max-depth=1 /mnt/01/
$ du -h --max-depth=1 /mnt/01/
4.4G    /mnt/01/dev-01
3.7G    /mnt/01/dev-02
.
.
.
```

****************


###### 容量がヤバイときの対応

<a href=""
