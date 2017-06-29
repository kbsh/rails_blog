<%#
+++
date = "2016-11-28T14:07:51Z"
draft = false
title = "うるう秒対応"
categories = ["linux"]
+++
%>

+ [参考 英](https://access.redhat.com/articles/15145)
+ [参考 日](https://access.redhat.com/ja/node/1362753)
+ [参考 ブログ](https://hiroki.jp/leap-second-2015)

### 概要


うるう秒挿入にかんして、ntpを採用している場合、[CPU100%に張り付くバグ](https://www.sakura.ad.jp/news/sakurainfo/newsentry.php?id=655)が起こる可能性がある。

---


### 原因

カーネルかntpパッケージの脆弱性

---


### 対応必要性の判断

redhatより、うるう秒を挿入削除を繰り返すテストプログラムが用意されているので確認可能(確実なテスターではないよう)

 **サーバー時間を変更してしまうので実行時は注意** 

```
# kernel-headersパッケージのインストール(すでにインストールしている場合は必要なし)
yum list installed | grep kernel-headers
yum install kernel-headers
 
# コンパイラーのインストール(すでにインストールしている場合は必要なし)
yum list installed | grep gcc
yum install gcc
 
# 作業ディレクトリの作成
mkdir /tmp/leap
cd /tmp/leap/
 
# leap-a-day.cを取得
wget https://access.redhat.com/sites/default/files/attachments/leap-a-day.c
 
# ビルド
gcc leap-a-day.c -o leap-a-day -lrt
 
# テストプログラムの実行
./leap-a-day -s

# 時間を元に戻す
ntpdate ntp.nict.jp
```

`ERROR: hrtimer early expiration failure observed.`がでたら対応が必要


---


### 対応方法


###### カーネルのバージョンアップ

RHEL6の場合、[2.6.32-358.el6未満だとだめらしい](http://www.rack.sh/linux-leap-second/)

確認コマンド

```
$ uname -a
```

※試してないのでバージョンアップ方法は未記載


###### ntpパッケージのバージョンアップ

[ntpd 4.2.6p5@3未満だとだめらしい](https://bugzilla.redhat.com/show_bug.cgi?id=1199978)

確認コマンド


```
$ ntpq -c rv
```

アップデート

再起動は後述の設定後に行う。


```
$ yum update ntp
```



###### ntpdをSLEWモードで起動

`SLEWモードは時間遡行させずに徐々に時刻修正するモード。`

現在の設定を確認(-xオプションがついているか)


```
$ ps aux | grep ntpd
ntp       1421  0.0  0.0  30740   776 ?        Ss   May31   0:16 ntpd -u ntp:ntp -p /var/run/ntpd.pid -g
501       5303  0.0  0.0 103328   868 pts/0    S+   10:54   0:00 grep ntpd
```

stop

```
$ service ntpd stop
```

カーネルの状態と頻度をリセット

```
$ ntptime -s 0 -f 0
```

SLEWモードにするため、-xオプションを付与

```
$ vi /etc/sysconfig/ntpd
- OPTIONS="-u ntp:ntp -p /var/run/ntpd.pid -g"
+ OPTIONS="-x -u ntp:ntp -p /var/run/ntpd.pid -g"
```

start

```
$ service ntpd start

```

