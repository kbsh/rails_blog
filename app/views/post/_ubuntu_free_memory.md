<%#
+++
date = "2017-08-30T12:13:51Z"
draft = false
title = "Ubuntuでメモリ解放する"
categories = ["ubuntu"]
+++
%>

そもそもミドルウェアに割りあてるメモリ上限を見直すことをおすすめします・・。

一時対応策としては下記が有効。未使用キャッシュをクリアするコマンドです。


### 状況

- メモリ使用率がカツカツ
- topやpsで確認しても怪しいプロセスが無い

### 確認

```
# 確認
free
# 使用メモリの詳細
cat /proc/meminfo
# Slab領域の確認
sudo slabtop
```

### キャッシュクリア

> drop_cachesは、既に利用されておらず、ストレージと同期の取れているページキャッシュやSlabキャッシュをMemFreeに移動してくれます。

下記手順は安全なキャッシュクリアなので、無条件に両方クリアしても問題なさそうです。

- `free`でcachedが高い場合
  - ページキャッシュクリア？
- `/proc/meminfo`でslabが高い場合
  - slabキャッシュクリア？

```
# キャッシュクリア（ページキャッシュ）
echo 1 > sudo /proc/sys/vm/drop_caches
# キャッシュクリア（Slabキャッシュ）
echo 2 > sudo /proc/sys/vm/drop_caches
# キャッシュクリア（ページキャッシュ、Slabキャッシュ）
echo 3 > sudo /proc/sys/vm/drop_caches
``

(こんな感じでいいんだろうか。)

### Slab

- Slabキャッシュ
 - ディレクトリのメタデータ情報(dentry)
 - ファイルのメタデータ情報(inode構造体)
