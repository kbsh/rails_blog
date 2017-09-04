<%#
+++
date = "2015-07-13T15:13:51Z"
draft = false
title = "facebookいいねが下にずれる件"
categories = ["blog"]
+++
%>


twitterのtweet, facebookのいいねを併設したときの<br>
いいねの位置が下にずれる件の対処法です。

こちらの原因は、facebookのcssに`vertical-align:bottom`があるせいです。<br>

以下の用に書き換えましょう。

HTML

```
<div class="social_buttons"><!-- ここ追加 -->
    <!-- いいね -->
    <div class="fb-like".....></div>
    <!-- tweet -->
    <iframe id="twitter-widget-0".....></div>
</div>
```

CSS

```
.social_buttons > * {
    vertical-align: bottom;
}
```

facebookに合わせて全てのソーシャルボタンの垂直位置を下に揃えることで対応しました。

cssの`>`が子要素を表すもの。<br>
`*`が全ての要素を表すものです。

cssが分からないという方は、<br>
`<iframe id="twitter-widget-0" style="vertical-align: bottom;">`<br>
と直接HTMLに書きましょう。


