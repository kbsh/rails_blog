<%#
+++
date = "2015-07-13T14:45:51Z"
draft = false
title = "twitter tweetボタン設置"
categories = ["blog"]
+++
%>


SNSシェア機能の第２弾。twitterです。

[こちら]( https://about.twitter.com/ja/resources/buttons#tweet )にアクセスし、tweetボタンを作成します。

FBと違い、デフォルトでURLを自動取得してくれる模様。<br>
これはうれしい！
コードプレビューの下にあるのタグをコピーし、HTMLに貼り付けましょう。

```
<!-- HTMLタグ -->
<a href="https://twitter.com/share" class="twitter-share-button" target="_blank">Tweet</a>

<!-- jsタグ -->
<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>
```

Tweetボタン設置はこれでおしまいです！<br>
FBより優秀！？<br>
おっと、誰か来たようだ。
