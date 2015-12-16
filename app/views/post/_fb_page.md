<%#
+++
date = "2015-07-17T19:28:51Z"
draft = false
title = "facebookファンページの設置"
categories = ["blog"]
+++
%>


facebookページ機能の実装です。<br>
facebookユーザーからの流入が欲しい場合は設置しましょう。


<a href="https://www.facebook.com/pages/create/">facebookページ作成</a>にて登録します。

```
ブランドまたは製品
↓
ウェブサイト
↓
基本データ設定
↓
プロフィール写真設定
```

<a href="https://developers.facebook.com/docs/plugins/page-plugin/">Page Plugin</a>
にてGet Codeしてタグを埋め込みます。


上にあるのがSDK用のタグ。<br>
既にいいねなどの他のFBプラグインを利用している人は不要です。

```
<div id="fb-root"></div>
<script>(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = "//connect.facebook.net/ja_JP/sdk.js#xfbml=1&version=v2.4&appId=xxxxxxxxxxxxxxxxxx";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));</script>

```

Comments用のコード。これを必要箇所に埋め込みます。<br>
data-hrefは各自異なります。



Page Pluginのコード。これを必要箇所に埋め込みます。<br>
xxxx...がURL。yyy...がfacebookid。zzz...がウェブサイト名です。

```
<div class="fb-page" data-href="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" data-small-header="false" data-adapt-container-width="true" data-hide-cover="false" data-show-facepile="true" data-show-posts="false"><div class="fb-xfbml-parse-ignore"><blockquote cite="https://www.facebook.com/yyyyyyyyyyyy"><a href="https://www.facebook.com/yyyyyyyyyyy">zzzzzzzzzzzzzzzzz</a></blockquote></div></div>
```

いいねなどの設置に慣れていれば問題なく組み込めるはず。

