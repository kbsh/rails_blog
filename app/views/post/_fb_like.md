<%#
+++
date = "2015-07-03T21:48:51Z"
draft = false
title = "facebook いいねボタン設置"
categories = ["blog"]
+++
%>

SNSシェア機能を設置しようとおもい、<br>
まずてはじめにfacebook先輩からやろうと思います。

### デベロッパー登録

まずはデベロッパー登録<br>
http://developers.facebook.com/setup/


```
wwwを選択
↓
webページ名を登録
↓
セットアップSDKのタグを取得（後で使います）
↓
URLを登録
```

いいね、コメント、シェア、フォロー、送る・・
なにやらいろいろ機能があるみたいですね。<br>
コメントは後々埋め込みたいところ。

今回は
`ソーシャルプラグイン→いいね！ボタン`
を選びましょう。

次ページでデザインを選択し、`Get Code`ボタンでコードを発行しましょう。

```
1. Include the JavaScript SDK on your page once, ideally right after the opening <body> tag.

<div id="fb-root"></div>
<script>(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = "//connect.facebook.net/ja_JP/sdk.js#xfbml=1&version=v2.3&appId=xxxxxxxxx";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));</script>
```

こちらは共通です。<br>
js.srcのappIdは多分いらないです。

```
2. Place the code for your plugin wherever you want the plugin to appear on your page 
<div class="fb-like" data-href="xxxxxxxxxxxxxxxxxx" data-layout="standard" data-action="like" data-show-faces="true" data-share="true"></div>
```

これがデザインによって変わります。<br>
保存しておきましょう。<br>
data-href属性はお持ちのwebページのURLとなります。<br>
ブログなどの場合でページごとにカウントを取りたい場合は一手間必要です。<br>
<br><br>

***

### いいねボタン設置

では早速埋め込みます。

デベロッパー登録時に入手した`セットアップSDKのタグ`を埋め込みます。<br>
appId部分は変動値なので書き換えましょう。<br>
ちなみにjs.srcをコメント行と入れ替えればいいねがLIKEになりますw

````HTML
<div id="fb-root"></div>
<script src="/xxxxxxxxxxx.js"></script>
````

````javascript
(function(d, s, id){
    var js, fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) {return;}
    js = d.createElement(s); js.id = id;
    // js.src = "//connect.facebook.net/en_US/sdk.js";// アイコンが地味にLIKEになる。
    js.src = "//connect.facebook.net/ja_JP/sdk.js#xfbml=1&version=v2.0";
    fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));
````

javascriptは`<script></script>`で囲んでHTMLにぶち込んでも良いです。
これでおしまいです。超カンタン。<br>
設置するだけならこれでおしまい。以下は番外編です。<br><br>


***

### ページごとにリンクを作りたい場合

````javascript
// facebookいいね ページごとにリンクを書き換え
var url = encodeURI( document.URL );
$( ".fb-like" ).attr( "data-href", url );
````

おしまいww<br>
調べると他の人は違うやり方してるようだけど、<br>
これが一番楽でしょ<br>

jQueryを使った文法なので、jQueryを使っていない人はこの機会にぜひ使ってください。

````HTML
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.0/jquery.min.js"></script>
````

これ埋め込んでおしまいです。<br><br>


***

### コメント欄が途切れる

ボタンをページ下部に設置したせいでコメント欄がちぎれてしまう現象の対処法です。<br>
これは調べても全くでてこないので大変でした。<br><br>


解決法は、コメント高さを随時取得し、BODY（正確にはBODYではないけど）の高さを変えてしまうというやり方です。<br>
では早速。<br>

facebookSDKのEvent Subscriptionクラスを使いたいので読み込みます。

````HTML
<!-- facebookSDK全読み込み -->
<script src='http://connect.facebook.net/ja_JP/all.js'></script>
````

````css
/* 最前面に表示するため */
.fb-like iframe {
  max-width: none !important;
  max-height: none !important;
  z-index: 9999;
  overflow: visible;
}
````

````javascript
window.fbAsyncInit = function() {
    FB.init({
        appId      : 'xxxxxxxxxxxxx',
        xfbml      : true,
        version    : 'v2.3'
    });
};

// 初期処理
FB.init({
    appId      : 'xxxxxxxxxxxxx',
    status     : false, // check the login status upon init?
    cookie     : true, // set sessions cookies to allow your server to access the session?
    xfbml      : true  // parse XFBML tags on this page?
});

// コメント欄が切れてしまうので高さを可変にする
FB.Event.subscribe( 'edge.create',
    function( response ) {

        // コメント欄を開いているかのステータス
        var is_open = false;

        // 500msごとに処理を繰り返す
        var timer = setInterval( function() {
            height = $( ".fb-like iframe" ).height();
            if ( is_open ) {
                // コメント欄を閉じた時の処理
                if ( height == 20 ) {
                    // 高さを元に戻す ※違和感があるので封印
                    // $( "footer" ).css( { "height" : "25px" } );

                    // 繰り返し処理を抜ける
                    clearInterval( timer );
                // コメント欄を改行で拡張させた時の処理
                } else if ( height!= now_height ) {
                    $( "footer" ).css( { "height" : height + "px" } );
                }
            } else {
                // コメント欄を開いた時の処理
                if ( height != 25 ) {
                    is_open = true;
                    now_height = height;
                    $( "footer" ).css( { "height" : ( now_height ) + "px" } );
                }
            }
        }, 500 );
    }
);

````

ボタンデザインによって`20`,`25`の定数部分が変動するかもです。<br>
jQueryで取得しろよと仰るあなた、ごもっとも。<br>
ちなみに<a href="https://developers.facebook.com/docs/reference/javascript/FB.Event.subscribe/v2.3">Event.subscribe</a>のドキュメントはこちらです。<br><br>

***

##### 以下、失敗談です。

ボタンが下すぎてコメント表示されてないじゃん・・・<br>
ということで、いいねボタンをタップした時にコメント欄の高さを取得してコメント欄を上、もしくは画面中央に移動させよう！と思いました。<br>

コメント欄の高さをいじろうとした時の挙動がこちら！

````javascript
var form = $( ".fb-like iframe" ).contents().find( "form" );
↓
Uncaught DOMException: Failed to read the 'contentDocument' property from 'HTMLIFrameElement': Blocked a frame with origin "http://sk-create.biz" from accessing a cross-origin frame
````

なんかエラってる・・。書き換えるどころかiframeのDOMを取得できない・・。<br>
どうやら、ドメイン違うからアクセスできないようですね・・。<br>
雑兵ごときがFB様の作ったソースいじるな！ということですかね。<br>
iframeごと移動させることはできるんですけど、<br>
そうするとボタンも一緒についてくるんですよね・・。<br>
ちょっと想定と違いうんですよね・・・。
<br>

ということで、FB様のDOMをいじることはあきらめ、自分のDOMを書き換えるよう方針転換しました。
<br><br>以上です。

