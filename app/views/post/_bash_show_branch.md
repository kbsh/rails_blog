<%#
+++
date = "2016-02-02T11:16:51Z"
draft = false
title = "zshを使わずにコマンドラインにgitブランチ名を表示する"
categories = ["git","linux"]
+++
%>

### ブランチ名表示

git-promptを取得する。<br>
配置場所やファイル名は各自の好きなように・・。

```
$ wget -O .git-prompt.sh https://raw.github.com/git/git/master/contrib/completion/git-prompt.sh
```

bashrcで設定

```
$ vi .bashrc

+ # ブランチ名を表示したい
+ if [ -f ~/.git-prompt.sh ]; then
+   source ~/.git-prompt.sh
+ fi
+ GIT_PS1_SHOWDIRTYSTATE=true
+ export PS1='\[\033[32m\]\u@\h\[\033[00m\]:\[\033[34m\]\w\[\033[31m\]$(__git_ps1)\[\033[00m\]\$ '
```

bashrcを再読み込み

```
$ source ~/.bashrc
```

******

##### もしかしたら環境によっては下記設定も必要かも・・。

git-completion.bashを取得する。

```
$ cd
$ wget -O .git-completion.bash https://raw.github.com/git/git/master/contrib/completion/git-completion.bash
```

bashrcで設定

```
$ vi .bashrc

+ if [ -f ~/.git-completion.bash ]; then
+   source ~/.git-completion.bash
+ fi
```

bashrcを再読み込み

```
$ source ~/.bashrc
```

