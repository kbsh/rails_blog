<%#
+++
date = "2016-09-13T13:57:51Z"
draft = false
title = "google apps script(gas)をapiで呼びだしてメールを送る"
categories = ["linux"]
+++
%>

### GASのAPI IDを発行する


公開→実行可能APIとして導入
![image](https://cloud.githubusercontent.com/assets/11205591/18462146/ae23b610-79ba-11e6-9f79-1978248a4abe.png)

発行された。
![image](https://cloud.githubusercontent.com/assets/11205591/18462168/e7606fa4-79ba-11e6-897f-8a744e44fccd.png)


---


### スクリプトIDとOAuthスコープをメモする

ファイル→プロジェクトのプロパティ
![image](https://cloud.githubusercontent.com/assets/11205591/18462194/242e6422-79bb-11e6-9c3c-44d28f87e6e6.png)

スクリプトID(URIからもわかる。)
![image](https://cloud.githubusercontent.com/assets/11205591/18462238/77bf2630-79bb-11e6-8b5d-dc0d280d0ff7.png)

OAuthスコープ
![image](https://cloud.githubusercontent.com/assets/11205591/18462472/84f48c62-79bd-11e6-9541-0f9000df51d9.png)


---


### google developerのプロジェクト作成を行う

[参考](http://sk-create.biz/post/search?i=59)


---

### GASとプロジェクトを紐付ける

project番号を[こちら](https://console.developers.google.com/iam-admin/settings)から取得する

![image](https://cloud.githubusercontent.com/assets/11205591/18462347/59e2008c-79bc-11e6-839c-137f5849faf0.png)


リソース→Developers Consoleプロジェクト
![image](https://cloud.githubusercontent.com/assets/11205591/18462306/135340ae-79bc-11e6-890a-8d88a65eda71.png)

プロジェクトの変更。consoleで入手したproject番号を入力する
![image](https://cloud.githubusercontent.com/assets/11205591/18462376/a06ccb2c-79bc-11e6-8bad-07329860491b.png)


---

### APIコールサンプル


get_api_token.sh

```
#!/bin/bash
#
# Google APIsのアクセストークンを取得する

CLIENT_ID=xxxxxxxxxxxxxxx
CLIENT_SECRET=xxxxxxxxxxxxxx
REDIRECT_URI=http://localhost/oauth2callback
SCOPE=//mail.google.com/
AUTHORIZATION_CODE=xxxxxxxxxxxxxxxxxxx

# APIトークン、リフレッシュトークンを取得する。一度取得したら削除し、下のコメントを解除すること
api_token=`curl --data "code=$AUTHORIZATION_CODE" --data "client_id=$CLIENT_ID" --data "client_secret=$CLIENT_SECRET" --data "redirect_uri=$REDIRECT_URI" --data "grant_type=authorization_code" --data "access_type=offline" https://www.googleapis.com/oauth2/v4/token`

#REFRESH_TOKEN=xxxxxxxxxxxxxxxxxxx
#api_token=`curl --data "refresh_token=$REFRESH_TOKEN" --data "client_id=$CLIENT_ID" --data "client_secret=$CLIENT_SECRET" --data "grant_type=refresh_token" https://www.googleapis.com/oauth2/v4/token`

echo $api_token | jq .access_token
```

SCOPEはGASのプロパティから取得したもの。各種APIによって異なる


---


call_gas_send_email.php

```
<?php
/**
 * GASを呼び出し、メール通知する
 */

$subject          = $argv[1];
$body             = $argv[2];

$script_id = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
$api_key   = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
$url       = "https://script.googleapis.com/v1/scripts/$script_id:run?key=$api_key";

$authorization = shell_exec('get_api_token.sh');

$body = str_replace(" ", "", $body);
$body = str_replace("/", "\n", $body);

$params = array(
  'function'   => 'xxxxxxxxxxxxxxxxxxxxx',
  'parameters' => array($subject, $body),
  'devMode'    => true
);
$json = json_encode($params);

$header = array(
  "Authorization: Bearer $authorization",
  'Content-Type: application/json',
  'Content-Length: ' . strlen($json)
);

$conn = curl_init();

curl_setopt($conn, CURLOPT_SSL_VERIFYPEER, true);
curl_setopt($conn, CURLOPT_CONNECTTIMEOUT, 2);
curl_setopt($conn, CURLOPT_FOLLOWLOCATION, 1);
curl_setopt($conn, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($conn, CURLOPT_HEADER, true);
curl_setopt($conn, CURLOPT_URL, $url);
curl_setopt($conn, CURLOPT_POST, true);
curl_setopt($conn, CURLOPT_POSTFIELDS, $json);
curl_setopt($conn, CURLOPT_HTTPHEADER, $header);

$response = curl_exec($conn);

curl_close($conn);
```

`php call_gas_send_email.php [件名] [本文]`

+ スクリプトIDは上記でメモしたもの。
+ APIキーはこの記事には記載がないが、[参考](http://sk-create.biz/post/search?i=59)から入手してください。
+ functionはGASの関数名


---

### GASサンプル

```
/**
 * KPIをメール通知します
 *
 * @param string subject 件名
 * @param string body    本文
 *
 */
function sendKpi( subject, body ) {
  var send_to   = "xxxxxxxxxxxxxxxxxxxxxx";
  var send_from = {
    from: "xxxxxxxxxxxxxxxxxxx",
    name: "xxxxxxxxxxxxxxxxxxx"
  };
  
  // Emailを送信します
  GmailApp.sendEmail ( send_to, subject, body, send_from )
}
```

