/* 画面読み込み後に引数の関数をコールする
*  Turbolinksのせいで遷移時にreadyが発火しないからラップした。
*  @params [function] fnc read後に呼びたい関数
*/
function documentReady ( fnc ) {
  $(document).on( 'page:load', fnc );
  $(document).ready( fnc );

}

