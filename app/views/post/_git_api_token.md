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

documentは[こちら](https://developer.github.com/v3/oauth_authorizations)


### 確認手順

user nameは置き換えましょう。

```
curl -u 'shoheikitabatake' https://api.github.com/authorizations
Enter host password for user 'shoheikitabatake':                                                                
```

******************

### 作成手順

そもそも持っていない人は下記。
もしくは[ここ](https://github.com/settings/tokens)から


```
$ curl -u 'shoheikitabatake' -d '{"scopes":["repo"],"note":"Help example"}' https://api.github.com/authorizations
Enter host password for user 'shoheikitabatake':
```
