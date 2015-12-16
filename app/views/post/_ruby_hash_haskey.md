<%#
+++
date = "2015-10-28T18:32:51Z"
draft = false
title = "[ruby]ハッシュキーの存在確認"
categories = ["ruby"]
+++
%>


```
def getValue( key )
  if ! @hash[key]
end
```

というようなように`! hoge`で存在確認をしようとすることもあろう。

この場合、もしkeyが存在しなかった場合、`@hash`に`key`が追加されてしまう・・・・・・・・・・・。
つまり`@hash[key] = nil`みたいな動作をしてしまう・・・・・・・。


###### ハッシュの存在確認はhas_keyをつかおう

```
def getValue( key )
  if ! @hash[key].has_key
end
```

これで存在確認のたびにkeyが追加されることはない。
