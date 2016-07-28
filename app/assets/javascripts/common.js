/**
 * 画面読み込み後に引数の関数をコールする
 * Turbolinksのせいで遷移時にreadyが発火しないからラップした。
 *
 * @params [function] fnc read後に呼びたい関数
 */
function documentReady ( fnc ) {
  $(document).on( 'page:load', fnc );
  $(document).ready( fnc );
}

/**
 * リンクをタブで開くようにする
 */
documentReady(function(){
  $("a[href^='http']:not([href*='" + location.hostname + "'])").attr('target', '_blank');
});
