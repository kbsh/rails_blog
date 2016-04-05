<%#
+++
date = "2016-03-17T14:34:51Z"
draft = false
title = "gitリポジトリのユーザーを変更する"
categories = ["git"]
+++
%>

サーバー上のgitリポジトリのユーザーを変更する手順です。


### 新しいアカウントでSSH KEYを作成する


###### 既存のアカウントの鍵を退避する（問題なければ削除）

```
$ cd ~/.ssh/
$ mv id_rsa id_rsa_tmp
$ mv id_rsa.pub id_rsa.pub_tmp

$ ls
id_rsa_tmp      id_rsa.pub_tmp
```

###### 新しく鍵を作成する（すでにあればコピーすれば以下の手順はすべて不要）

```
$ ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
# Creates a new ssh key, using the provided email as a label
Generating public/private rsa key pair.

$ ls
id_rsa  id_rsa.pub  id_rsa.pub_tmp  id_rsa_tmp
```

パスフレーズはよしなに。


###### パスフレーズを設定した場合はssh-agentに登録する

``
$ ssh-add ~/.ssh/id_rsa
```


### 公開鍵をgithubに登録する

###### クリップボードにコピー

```
windows
$ clip < ~/.ssh/id_rsa.pub

mac
$ pbcopy < ~/.ssh/id_rsa.pub
```

###### githubのプロフィールページで鍵を登録

アカウントに対し、公開鍵を設定する
https://github.com/settings/keys


### ユーザーが変わっているか確認する

```
$ ssh -T git@github.com
Hi username! You've successfully authenticated, but GitHub does not
provide shell access.'
```

