<%#
+++
date = "2016-10-28T11:36:51Z"
draft = false
title = "abで負荷テスト"
categories = ["linux"]
+++
%>

### abとは

apache標準搭載の負荷測定ツール


```
ab -c20 -n100000 http://localhost/index.php
```

オプション | 意味
--- | ---
c | 同時接続数
n | リクエスト数


---

### 実行例

```
[admin@infradev-01 php]$ ab -c100 -n100 localhost/php/index.php
Server Software:        Apache/2.2.15
Server Hostname:        localhost
Server Port:            80


Document Path:          /php/index.php
Document Length:        27 bytes


Concurrency Level:      100
Time taken for tests:   0.009 seconds
Complete requests:      100
Failed requests:        0
Write errors:           0
Total transferred:      29896 bytes
HTML transferred:       2727 bytes
Requests per second:    11385.63 [#/sec] (mean)
Time per request:       8.783 [ms] (mean)
Time per request:       0.088 [ms] (mean, across all concurrent requests)
Transfer rate:          3324.07 [Kbytes/sec] received


Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    3   0.3      3       3
Processing:     1    3   1.1      3       5
Waiting:        0    3   1.1      3       5
Total:          2    5   1.1      5       7
```

`Requests per second`をよくみる
