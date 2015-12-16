<%#
+++
date = "2015-07-09T17:33:51Z"
draft = false
title = "rubyのyield、ブロック、Procについて"
categories = ["ruby"]
+++
%>


unityコルーチンでおなじみのyield（イールド）さん。<br>
rubyでも登場してきたので考察します。<br>
yieldを考えるのにあたって必要な関連知識は<br>
`ブロック`、`Proc`、 そして`yield`の３つ<br><br>

***

##### ブロックとは
`do～end、{～} で囲まれた処理のカタマリ。メソッドの引数となる。`

##### Procとは
`ブロックをオブジェクトしたもの`

##### yieldとは
`ブロックを呼び出すメソッド`

ブロックという一連の処理をコールするための手段として、<br>
Proc、yieldがあるという認識です。<br><br>

***

### yieldの場合

```
def foo
    yield
end

foo do
    p "hoge"
end

#=> "hoge"
```

do～endで囲まれる`p "hoge"`部分がブロックです。<br>
fooメソッドがコールされ、yieldでブロックがコールされています。<br><br>

***

### Procの場合

```
def bar ( &arg )
    arg.call
end

bar { p "fuga" }

#=> "fuga"
```

引数の頭についた`&`、これは、引数にブロックが渡された場合、<br>
`Procオブジェクト`として受け取っています。<br>
Procオブジェクトは`call`で呼び出せます。<br>
また、ブロック引数以外にも引数をうけとれる場合、ブロック引数は最後に定義する必要があります。<br><br>


***

Procとyield、２つの手段がありますが、簡潔な分yieldのほうがよさそうですね。<br><br>

ただ、Procにもメリットがあります。<br>
それはオブジェクトとして使える点です。<br>
インスタンス変数としてブロックを保持し、好きなときにコールすることが出来ます。

```
bar = Proc.new do | arg |
    p arg
end

foo.call ( "hoge" )
foo.call ( "fuga" )

#=> "hoge"
#=> "fuga"
```


***

### ブロックに引数を渡す場合（yield）

```
def foo
    # 第一引数に1, 第二引数に2をブロックに渡します
    yield ( 1, 2 )
end

foo do | a, b, c | # 第三引数までうけとれるブロック
    p [ a, b, c ]
end

#=> [ 1, 2 nil ]
```

第三引数までうけと"れる"、と可能形で書きましたが、<br>
今回の例示のように、引数を渡さないことも可能です。

