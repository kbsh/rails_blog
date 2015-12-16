<%#
+++
date = "2015-10-06T17:36:51Z"
draft = false
title = "[rails]User認証gem[devise]で未ログイン時にログインページに飛ばす"
categories = ["rails"]
+++
%>


### はじめに
<a href='https://github.com/plataformatec/devise'>Devise gem</a>がインストールされている前提です。

### 未認証時にエラーにする

vi app/controllers/application_controller.rb
```
before_filter :authenticate_user!, unless: :devise_controller?
```

共通コントローラで未認証時にエラーとする判定をいれる。<br>
unless以降がなかったらuserControllerへのアクセス時も引っかかってしまい、リダイレクトループとなる。<br>
ぐぐってもでてこなかったので、正直これのためだけに記事書いた。


***


### エラー時のリダイレクト先を指定する
<a href='https://github.com/plataformatec/devise/wiki/How-To:-Redirect-to-a-specific-page-when-the-user-can-not-be-authenticated'>公式wiki</a>
railsバージョンでちがうぽい。

vi lib/custom_failure.rb
```
class CustomFailure < Devise::FailureApp
  protected
  def redirect_url
#      root_path #rootに飛ばす場合
      root_path+"users/sign_in" # ログインページに飛ばす場合
  end
end
```

新規作成。deviseの親クラスを書き換え。<br>
<a href='https://github.com/plataformatec/devise/wiki/How-To:-Redirect-to-a-specific-page-when-the-user-can-not-be-authenticated'>公式wiki</a>に書いてあるので多分大丈夫。

vi config/initializers/devise.rb
```
config.warden do |manager|
    manager.failure_app = CustomFailure
  end
```

vi config/application.rb
```
config.autoload_paths << Rails.root.join('lib')
```

作成したクラスを読み込むように書き換える。


