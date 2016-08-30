<%#
+++
date = "2016-08-23T18:34:51Z"
draft = false
title = "ディレクトリ以下のファイル内全置換"
categories = ["linux"]
+++
%>

ファイル名ではなく、ファイルの中身を全置換。



```
cd [全置換したいpath]
find . -type f | xargs sed -i 's/[置換前]/[置換後]/g'
```
