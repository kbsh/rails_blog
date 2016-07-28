<%#
+++
date = "2016-07-22T12:47:51Z"
draft = false
title = "EC2サーバーにディスク( EBS )を追加"
categories = ["linux", "aws"]
+++
%>

### 概要

サーバー容量不足のためディスク容量を追加する手順

---

### EBSのレンタル

1. awsにログイン
2. EC2から`ELASTIC BLOCK STORE`のボリュームにアクセス
3. ボリュームの作成
4. ボリュームのアタッチ

そんな料金変わらないし基本SSD( GP2 )で良いと思う。

ただし、サイズ選択に下限があるので注意（いくつかは忘れた）

アタッチするボリュームは対象のEC2インスタンスにすること。

---

### ディスクのマウント

[AWSヘルプ](http://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/ebs-using-volumes.html)を参照すること

```
    1  cd /
    2  ls
    3  sudo mkdir data
    4  lsblk
NAME  MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
xvdf  202:80   0  100G  0 disk
xvda1 202:1    0    8G  0 disk /
    5  sudo file -s /dev/xvdf
/dev/xvdf: data
    6  sudo mkfs -t ext4 /dev/xvdf
    7  sudo mount /dev/xvdf /data/
    8  df -h
    9  sudo cp /etc/fstab /etc/fstab.orig
   10  sudo vi /etc/fstab
+ /dev/xvdf       /data   ext4    defaults,nofail        0       2
   11  sudo mount -a
```

+ `file -s`でファイルシステムの存在確認をしている。`data`は未存在。
+ `mkfs`でファイルシステムを作成している。
  + ext4はext3の後継ファイルシステムらしい。
  + 記事作成時の情報なので最新を確認すること。
+ df -hで確認するとマウントされていることがわかる。
+ `/etc/fstab`に追記することで起動時にマウントしてくれるらしい。
+ `mount -a`は不具合がないか確認している

---

### 注意事項

**マウント先に既存のディレクトリ**を使用する場合、データが上書かれてしまうため、退避すること**

