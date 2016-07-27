<%#
+++
date = "2016-06-02T14:04:51Z"
draft = false
title = "github api tokenの確認方法"
categories = ["git"]
+++
%>

github api tokenを忘れてしまった人へ。<br>
下記コマンドで確認できます

documentは<a href="https://developer.github.com/v3/oauth_authorizations" target="_blank">こちら</a>


### 確認手順

user nameは置き換えましょう。

```
curl -u 'shoheikitabatake' https://api.github.com/authorizations
Enter host password for user 'shoheikitabatake':                                                                
```

******************

### 作成手順

そもそも持っていない人は下記。
もしくは<a href="https://github.com/settings/tokens" target="_blank">ここ</a>から


```
$ curl -u 'shoheikitabatake' -d '{"scopes":["repo"],"note":"Help example"}' https://api.github.com/authorizations
Enter host password for user 'shoheikitabatake':
```
