<%#
+++
date = "2015-10-29T19:23:51Z"
draft = false
title = "[Rais]jsが動作しない時の対処法"
categories = ["rails","js"]
+++
%>


### 前提として

`turbolinks`というgemが標準で使われています。<br>
こちら、初回起動時にasset( css, js )を全読み込みし、遷移したときはDOMを書き換えるだけで済ませる。<br>
という高速化をしてくれる便利なgemです。


### 事案１

DOMが読み込まれた際に発火する`$( document ).ready()`というものがありますが、<br>
F5で再読み込みをした時は動くけどlink_toなどで遷移した時は動かないということがあります。

これ原因は`turbolinks`。<br>
先述の通り、読み込み直しをせずにDOMだけ書き換えています。
そのため`ready` は発火しません。

そんなときはこいつ使ってね。
```
/* 画面読み込み後に引数の関数をコールする
 * Turbolinksのせいで遷移時にreadyが発火しないからラップした。
*/ @params [function] fnc read後に呼びたい関数
function documentReady ( fnc ) { 
  $( document ).on( 'page:load', fnc );
  $( document ).ready( fnc );
}
```


*********

### 事案２

railsの標準では`//= require_tree .`とassetを全読み込みをしているが、<br>
使わないasset読み込みたくないし・・・と外してしまった時。

こちらも`turbolinks`絡み。<br/>
turbolinksは初回起動時にアセットを全読み込みする前提で動いているので<br>
アセットを個別読み込みしたいなら自分でレンダリングしないといけません。

とりあえずプリコンパイルしましょう。

```
$ vi config/environments/production.rb

+ config.assets.precompile += [ 'hoge.js', 'hoge.css' ]
```

でもって使うviewで読み込みましょう。

```
$ vi app/views/hoge/index.html.erb

+ <%= javascript_include_tag "hoge", "huga" %>
```

１行目に書きましょう。複数アセット読み込みたい場合は↑のように第二引数、第三引数に渡しましょう。

