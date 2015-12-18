<%#
+++
date = "2015-16-07T16:43:51Z"
draft = false
title = "[arel]rails Active Recordでサブクエリを使う"
categories = ["ruby","rails","sql"]
+++
%>

railsにて、サブクエリを使いたい時。<br>
`belongs_to`と`arel`のふた通りのやり方がある。<br>


************

### arel

ORMで解決する`belongs_to`とは異なり、クエリを精査するパターン。<br>
生でSQLを書くときに近い自由度がある。

bookに対し、複数のorderがある場合。

| tags | 説明 |
| --- | --- |
| id | - |

| content_tags | 説明 |
| --- | --- |
| id | - |
| tag_id | - |
| content_id | - |
| tag_id | content_tag : tag = n : 1 |
| content_id | content_tag : content = n : 1 |

| contents | 説明 |
| --- | --- |
| id | - |



###### 設定

belongs_toの設定（参照）<br>
2テーブル時はなくてもよい。


###### 使い方

渡ってきた`tag_id`に紐づく`contents`が欲しい場合。<br>
直接tagとcontentが繋がっていないのでbelongs_toでの並び替えなどが使いづらい


vi hoge_controller.rb

```
# パラメータ
tag_id = params[ :ti ]

content = Content.arel_table
content_tag = ContentTag.arel_table

@contents = Content.where( # select from content where
  content_tag # from content_tag
    .project( Arel.star ) # select *
    .where( content_tag[ :content_id ].eq( content[ :id ] ) ) # where content_tag.content_id = content.id
    .where( content_tag[ :tag_id ].eq( tag_id ) ) # and content_tag.tag_id = #{ tag_id }
    .exists # exists
).order( :created_at => :desc )
```

発行されたSQLがこちら。
`SELECT "contents".* FROM "contents" WHERE (EXISTS (SELECT * FROM "content_tags" WHERE "content_tags"."content_id" = "contents"."id" AND "content_tags"."tag_id" = 13))  ORDER BY "contents"."created_at" DESC`

他、`join`, `on`メソッドなどいろいろ使えるので自由度が高い。

***********

`arel`に関しては以上。`belongs_to`はこちら。

