<%#
+++
date = "2015-16-07T16:07:51Z"
draft = false
title = "[belongs_to]rails Active Recordでサブクエリを使う"
categories = ["ruby","rails","sql"]
+++
%>

railsにて、サブクエリを使いたい時。<br>
`belongs_to`と`arel`のふた通りのやり方がある。<br>


************

### belongs_to

modelにてテーブル同士を関連づけることによって、n対nの関係で結びつける方法。<br>
viewからのアクセスも割と自由。
サブクエリを使う使わないに関わらず、設計時に設定しておくとよい。

<a href="http://railsdoc.com/references/belongs_to">ドキュメント参照</a>



bookに対し、複数のorderがある場合。

| books | 説明 |
| --- | --- |
| id | - |
| name | - |

| orders | 説明 |
| --- | --- |
| id | - |
| book_id | order : book = n : 1 |



###### 設定

```
$ vi app/models/book.rb

+ has_many :orders, dependent: :destroy, foreign_key: :book_id
```

`dependent: :destroy`によって、bookのレコードを削除した時、関連するorderレコードを削除する<br>
`foreign_key: :***`によって、idキーがordersテーブルのどのカラムと紐づくかを指定している。

※ 1対1の場合は`has_one :order`とする。

```
$ vi app/models/order.rb

+ belongs_to :order, foreign_key: :book_id
```

`foreign_key`は前述と同様。<br>
`belongs_to :order`に複数形の`s`がないことに注意。n対`1`なので。



###### 使い方

```
book = Book.find( 1 )

# 
orders = book.orders

orders.each do | order |
  # book.idに紐づく複数のorderレコードを取得。複数のActive Recordクラスが返る。
  orders = book.order

  orders.each do | order |
    logger.error order.id
    logger.error order.book_id
  end
end
```

```
orders = Order.all

orders.each do | order |
  # order.book_idに紐づくbookのクラスを取得する。Active Recordクラスとして返る。
  book = order.book

  logger.error book.id
  logger.error book.name
end
```


***********

つかこれサブクエリとはいわないよね。<br>
サブクエリ的なことがしたいときということで・・・。

`belongs_to`に関しては以上。`arel`はこちら。<br>

