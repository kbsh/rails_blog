<%#
+++
date = "2016-06-09T17:13:51Z"
draft = false
title = "[linux]サーバー容量超過対策"
categories = ["linux"]
+++
%>

サーバーの容量超過対策としてやっていること

1. logファイルのクリア
2. gitの軽量化

************************


### logファイルのクリア

ドメイン分岐しておき、連番でディレクトリをわけて同様の構成でlogファイルが配置されていると想定

```
$ vi /mnt/data-01/hoge/clean_log.sh


#!/bin/bash

#引数の数だけループさせる
for i in $*; do
    # errorログをクリア
    sudo rm /mnt/data-01/dev-0$i/log/error/*
    # accessログをクリア
    sudo rm /mnt/data-01/dev-0$i/log/access/*
done
```


可変引数でドメイン名を渡して一括実行。<br>
`rm`しちゃいけないばあいは`cp /dev/null [ファイル名]`とするなど、柔軟に

****************************

### gitの軽量化


```
$ vi /mnt/data-01/hoge/clean_git.sh


#!/bin/bash

#引数の数だけループさせる
for i in $*; do
    toDirectory="/mnt/data-01/dev-0$i/{gitリポジトリ}"

    # ディレクトリ存在確認
    if [ -e $toDirectory ]; then
        # git gcを行う
        cd $toDirectory
        sudo git gc

        # 所有権をもどす
        sudo chown -R dev-0$i:dev-0$i .git/

        echo "done git gc $i"
    fi
done
```

`sudo`で`git gc`行うと`.git`直下のファイルの所有権が変わってしまうようなので所有権を戻す対応を行っている。<br>
`sudo`しなくていい場合は`chown`は不要



********************************


### 自動実行

様子をみて実行だと面倒なので`crontab`に登録してシステムに自動実行させる

```
$ crontab -e


# clean log for all environments
# within 1 minute
00 04 * * 7 /mnt/data-01/hoge/clean_log.sh 1 2 3 4 5 6 7 8 9 >>/mnt/data-01/hoge/debug.log 2>>/mnt/data-01/hoge/debug.log

# done git gc for all environments
# about 5 ~ 10 minutes
10 04 * * 7 /mnt/data-01/hoge/clean_git.sh 1 2 3 4 5 6 7 8 9 >>/mnt/data-01/hoge/debug.log 2>>/mnt/data-01/hoge/debug.log

```

上記では日曜日の4時に実行するように設定<br>
個人的に、crontabに実行時間の目安を書いておくと管理が楽。
