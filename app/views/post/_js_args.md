<%#
+++
date = "2015-10-29T18:46:51Z"
draft = false
title = "[js]関数の引数の数を可変で受け取る"
categories = ["js"]
+++
%>

```
// 可変引数をconsoleに出力する。定義に引数の情報は書かなくて良い。
function putLogArgs() {
  // argumentsに配列として引数が入る。
  for ( var i=1; i <= arguments.length; i++ ) {
    console.log( arguments[i] );
  }
}
```

