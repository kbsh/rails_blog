<%#
+++
date = "2015-07-15T17:22:51Z"
draft = false
title = "facebookコメント設置"
categories = ["blog"]
+++
%>


ブログというからにはコメント欄を付けたい。<br>
でも記事ごとにDBでデータ保持してとかめんどくさいなー・・<br>
と思っていたらいいものを発見。<br>
その名も`facebook Comments`！<br>

記事ごとにコメントを保持しつつ、FBで拡散する用途も果たすという優れもの！<br>
ちょっと前まではtwitterでお内↑音ができた`DISCUSS`というのが流行っていたらしい。<br>
今回もfacebookコメントにするか、DISCUSSにするか悩んだのですが、<br>
そもそもtwitterやってないし・・・ということでDBに決定。


### 実装手順

1. [`facebook Developers`](https://developers.facebook.com/)に登録

2. [`Social Plugins > Comments`](https://developers.facebook.com/docs/plugins/comments)にアクセス。

3. Get Codeからコードを取得

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

```
<div class="fb-comments" data-href="http://xxxxxx" data-numposts="5"></div>
```

### ページごとにコメントを分けたいかた
[こちらの記事](http://sk-create.biz/post/search?i=5/#ページごとにリンクを作りたい場合:52be3e469a9f216425e58d03ea24ad88)を参照ください。


### ページ下部に設置しすぎてコメントが切れちゃうというかた
私が実装したところ、コメントをすると都度親要素の高さを変えてくれたので大丈夫でしたが、<br>
もしそういう目にあったかたは[こちらの記事](http://sk-create.biz/post/search?i=5/#コメント欄が途切れる:52be3e469a9f216425e58d03ea24ad88)を参照ください。<br>

