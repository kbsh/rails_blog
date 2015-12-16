<%#
+++
date = "2015-12-08T15:48:51Z"
draft = false
title = "[js]JavaScriptでcommandキーのkeyCodeを取得する"
categories = ["ruby"]
+++
%>


JavaScriptでのcommandキーのkeyCode
```
e.metaKey
```

なお、jQueryの`keydown`イベントには対応しているが、<br>
commandを押している場合`keypress`イベントが発火しない模様。
