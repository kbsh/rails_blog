<%#
+++
date = "2017-07-03 T14:07:51Z"
draft = false
tてitle = "[ec2][ubuntu]swap領域を設定してメモリ不足によるサーバーダウンを防ぐ"
categories = ["aws","linux"]
+++
%>


ec2から`t2.micro`インスタンスを借りているが、数週間、数ヶ月に1度くらいのペースでサーバーダウンしてしまう・・。

アタック受けてるのかな？くらいの認識で放置してましたが、そろそろ対策することに。


### 1. アタック対策

[fail2ban](https://www.fail2ban.org/wiki/index.php/Main_Page)なるツールをいれてみる。

一定期間に一定数エラーアクセスしたIPをアクセス制限するなるツールです。導入割愛。

------

### 2. メモリ（swap）領域確保（今回の記事！）

アタック対策してもまだ落ちるのでエラーログを漁ると、下記のエラーが。

```
ERROR: Cannot fork() a new process: Cannot allocate memory (errno=12)
Could not touch the server instance directory because fork() failed. Retrying in 2 minutes...
failed (11: Resource temporarily unavailable) while connecting to upstream
```

どうやらメモリ不足でおちているらしく、調べてみると、`t2.micro`インスタンスはswap領域がないらしい。

```
$ free
             total       used       free     shared    buffers     cached
Mem:       1016340     827436     188904        784     137080      59120
-/+ buffers/cache:     631236     385104
Swap:            0          0          0
```

たしかに、Swapが0

------

#### 対策として実行したコマンドがこちら(ubuntuサーバーです。Amazon LinuxやCentの場合違うやり方かも)

```
# 事前に残容量をしらべる（4G利用可能）
$ df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/xvda1      7.8G  3.1G  4.3G  43% /

# swapファイル作成
mkdir /var/swaps
touch /var/swaps/swap.img

# 割当
# RAM < 2GBの場合、RAM*2くらいが妥当らしいので、理想は2GBの割当。
# 残容量は4GBなので、まぁOKとして2GBを割り当てる。1M * 2048
 dd if=/dev/zero of=/var/swaps/swap.img bs=1M count=2048
2048+0 records in
2048+0 records out
2147483648 bytes (2.1 GB) copied, 32.3236 s, 66.4 MB/s

# 権限付与
$ chmod 600 /var/swaps/swap.img

# swap領域の作成
$ mkswap /var/swaps/swap.img
Setting up swapspace version 1, size = 2097148 KiB
no label, UUID=xxxx-xxxxx-xxxxxx

# swap領域を有効化
$ swapon /var/swaps/swap.img

# swap領域を自動マウント設定
$ vi /etc/fstab
+ /var/swaps/swap.img  swap   swap    defaults   0 0
```

swap領域ができていることを確認する
[swapサイズ参考](https://access.redhat.com/documentation/ja-JP/Red_Hat_Enterprise_Linux/6/html/Storage_Administration_Guide/ch-swapspace.html)


```
$ free
             total       used       free     shared    buffers     cached
Mem:       1016340     935420      80920        780      64944     455216
-/+ buffers/cache:     415260     601080
Swap:      2097148          0    2097148

$ df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/xvda1      7.8G  5.1G  2.3G  70% /
```

------

### 番外編

割当量を間違えてしまったからやり直したい場合

```
# swap領域を無効化
swapoff /var/swaps/swap.img
# swapファイルを削除
rm /var/swaps/swap.img
```

free, df -hで削除確認をし、再度touchから割当手順を行う
