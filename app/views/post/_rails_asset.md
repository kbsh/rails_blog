<%#
+++
date = "2015-10-29T17:41:51Z"
draft = false
title = "[Rais]共通で読み込むアセット（js,css）と、画面ごとに読み込むアセットを分ける"
categories = ["rails"]
+++
%>


###### jsの処理

まずはアプリケーション共通で読み込みたいものに対する処理

```
$ vi app/assets/javascripts/application.js

# assets/javascripts/以下を全読み込みが標準となっているので削除
-//= require_tree .

# アプリケーション共通で読み込むjs(ここではapp/assets/javascripts/bootstrap.js)を追加
+//= require bootstrap
```

次に、アプリケーションごとに読み込みたいものに対する処理

```
$ vi config/initializers/assets.rb

# app/assets/javascripts/hoge.jsをprecompileする
+Rails.application.config.assets.precompile += %w( hoge.js )
+Rails.application.config.assets.precompile += %w( huga.js )


$ vi app/views/hoge/hoge.erb

<!-- １行目にでも置いておく。１ファイルなら`, "huga"`は不要 -->
+<%= javascript_include_tag "hoge", "huga" %>
```

[プリコンパイル]( http://ruby.studio-kingdom.com/rails/guides/asset_pipeline )とは、アセットの結合や縮小をしてくれるそうです。

####### cssの処理

```
$ vi app/assets/stylesheets/application.css

# js同様、全読み込みを解除
- *= require_tree .

# 共通で読み込むcssを追加
+ *= require bootstrap_and_overrides
+ *= require scaffolds
```

アプリケーションごとに読み込みたいものに対する処理

```
$ vi config/initializers/assets.rb

# app/assets/stylesheets/hoge.cssをprecompileする
+Rails.application.config.assets.precompile += %w( hoge.css )
```

