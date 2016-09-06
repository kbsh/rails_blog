<%#
+++
date = "2016-09-05T15:44:51Z"
draft = false
title = "google APIをつかってスプレッドシートの中の値を取得する"
categories = ["linux"]
+++
%>


### Google APIsプロジェクトに参加する


[アクセス！！](https://console.developers.google.com/project)


sheets APIを選択

![image](https://cloud.githubusercontent.com/assets/16536071/18239397/0ce67098-7380-11e6-8138-33388cff4d8d.png)


project作成

![image](https://cloud.githubusercontent.com/assets/16536071/18239403/127105be-7380-11e6-8adb-1d5e687bca5c.png)

有効にする

![image](https://cloud.githubusercontent.com/assets/16536071/18239405/17fdbad6-7380-11e6-8a80-a8c25cc72084.png)


---


### 認証、鍵作成など


認証情報にすすむ

![image](https://cloud.githubusercontent.com/assets/16536071/18239407/1d38d5bc-7380-11e6-819c-60c1c0f1b176.png)

呼ぶだし元を選択肢、決定

![image](https://cloud.githubusercontent.com/assets/16536071/18239413/236558de-7380-11e6-9469-a36db622a83c.png)

key作成

このIPアドレスはたぶん省略してもよかった。

![image](https://cloud.githubusercontent.com/assets/16536071/18239422/3503ff3c-7380-11e6-879f-f7f165be4915.png)

**apiキーが発行されたのでメモっておく**

OAuthクライアントIDを発行

![image](https://cloud.githubusercontent.com/assets/16536071/18239436/4b9f34dc-7380-11e6-892e-bfa1eee42942.png)

webアプリケーションにしとく

![image](https://cloud.githubusercontent.com/assets/16536071/18239440/51fc7240-7380-11e6-876a-f9d0198adb91.png)

全部省略でいけそう

![image](https://cloud.githubusercontent.com/assets/16536071/18239447/5fdf443c-7380-11e6-9ce6-9011d30ab44d.png)

※訂正。リダイレクトURLとか設定が必要っぽい。

![image](https://cloud.githubusercontent.com/assets/16536071/18239455/6e945eb8-7380-11e6-808b-32df44361561.png)
  
**クライアントID、クライアントシークレットが発行されたのでメモっておく**


---


### コードを取得する

下記URLにブラウザからアクセスする

scopeは[document](https://developers.google.com/sheets/guides/authorizing)を参考にすること

```
client_id=さっき発行されたクライアントID
redirect_url=http://localhost/oauth2callback
scope=https://www.googleapis.com/auth/gmail.readonly
https://accounts.google.com/o/oauth2/auth?client_id={$client_id}&redirect_uri={$redirect_url}&scope={$scope}&response_type=code&approval_prompt=force&access_type=offline
```

リダイレクト先のURL伏せてある部分が**コードなのでメモっておく**
![image](https://cloud.githubusercontent.com/assets/16536071/18239690/e2604d9c-7381-11e6-8415-7afae86cabd5.png)

---


### APIトークンを取得するスクリプト

codeはリフレッシュトークンを作成するためのもので、一度きりしか使用できないよう。

また、apiトークンの使用期限は30分。

一度リフレッシュトークンを発行したら、これを使いまわすこと

```
#!/bin/bash
#
# Google APIsのアクセストークンを取得する

CLIENT_ID=xxxxxxxxxxxxxxx
CLIENT_SECRET=xxxxxxxxxxxxxx
REDIRECT_URI=http://localhost/oauth2callback
SCOPE=https://www.googleapis.com/auth/spreadsheets
AUTHORIZATION_CODE=xxxxxxxxxxxxxxxxxxx

# APIトークン、リフレッシュトークンを取得する。一度取得したら削除し、下のコメントを解除すること
api_token=`curl --data "code=$AUTHORIZATION_CODE" --data "client_id=$CLIENT_ID" --data "client_secret=$CLIENT_SECRET" --data "redirect_uri=$REDIRECT_URI" --data "grant_type=authorization_code" --data "access_type=offline" https://www.googleapis.com/oauth2/v4/token`

#REFRESH_TOKEN=xxxxxxxxxxxxxxxxxxx
#api_token=`curl --data "refresh_token=$REFRESH_TOKEN" --data "client_id=$CLIENT_ID" --data "client_secret=$CLIENT_SECRET" --data "grant_type=refresh_token" https://www.googleapis.com/oauth2/v4/token`

echo $api_token | jq .access_token
```

---

### スプレッドシートの値を取得する


```
spreadsheet_id=xxxxxxxxxxx
range=xxxxxx
curl -H "Authorization: OAuth $google_access_token" https://sheets.googleapis.com/v4/spreadsheets/{$spreadsheet_id}/values/{$range}
```

rangeは`{シート名}!A1:D3`といった形式

スプレッドシートIDはURLの伏字の部分
![image](https://cloud.githubusercontent.com/assets/16536071/18240055/515213fa-7384-11e6-829e-473b8872551e.png)
)]


