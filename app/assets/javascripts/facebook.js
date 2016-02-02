documentReady( function(){

window.fbAsyncInit = function() {
    FB.init({
        appId      : '858240187558951',
        xfbml      : true,
        version    : 'v2.3'
    });
};
(function(d, s, id){
    var js, fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) {return;}
    js = d.createElement(s); js.id = id; js.async = true;
//    js.src = "//connect.facebook.net/en_US/sdk.js";// アイコンが地味にLIKEになる。
    js.src = "//connect.facebook.net/ja_JP/sdk.js#xfbml=1&version=v2.0&appId=858240187558951";

    fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));

// 初期処理
FB.init({
    appId      : '858240187558951',
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

// ページごとにリンクを書き換え
// var url = encodeURI( document.URL );
// $( ".fb-like" ).attr( "data-href", url );// いいね
// $( ".fb-comments" ).attr( "data-href", url );// コメント

});
