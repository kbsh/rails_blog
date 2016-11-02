<%#
+++
date = "2016-11-01T12:13:51Z"
draft = false
title = "githubのprojectsを使ってTODO管理"
categories = ["git", "github"]
+++
%>

githubのProjects機能を使って漏れのない安全なリリース管理をしたい。

---

### まとめ

+ リリースバージョンごとにProjectを作成する
+ add columnして『リリースノート』、『TODO』、『TODO完了』を作成
    + 事前に『リリースノート』にアップデート項目を追加しておく
    + 事前にアップデート時にやらないといけないことを確認し、『TODO』に設定する
    + （『TODO』のレビューをする）
    + リリース前に『TODO』を確認し実行する
        + 完了した『TODO』を『TODO完了』に移動する

---

### 手順案内

#### 1. project作成

![image](https://cloud.githubusercontent.com/assets/16536071/19914254/3be740f4-a0ec-11e6-8fa9-e2fb72624985.png)

![image](https://cloud.githubusercontent.com/assets/16536071/19914282/78e0f022-a0ec-11e6-95c3-b2917016d06f.png)

作成された
![image](https://cloud.githubusercontent.com/assets/16536071/19914288/9ae4c90a-a0ec-11e6-8cd5-91b5fab8f16a.png)


#### 2. 『リリースノート』、『TODO』、『TODO完了』のcolumnを作成

![image](https://cloud.githubusercontent.com/assets/16536071/19914304/d1c2092e-a0ec-11e6-95ba-6d2a7d7baedb.png)

作成された
![image](https://cloud.githubusercontent.com/assets/16536071/19914389/a1f75220-a0ed-11e6-9e8f-3337da2d6a97.png)


#### 3. リリースノートにアップデート項目を追加

Add cards
![image](https://cloud.githubusercontent.com/assets/16536071/19914411/d1888658-a0ed-11e6-8656-bac5600eb0fe.png)

issue,PRを検索する
https://i.gyazo.com/f57a0063abbcec9fe1682203dceb2b15.png

対象のissue, PRをリリースノートにドラッグアンドドロップする
![image](https://cloud.githubusercontent.com/assets/16536071/19914475/525725c8-a0ee-11e6-8b0a-318ea6157dc6.png)

#### 4. リリース時のやることをTODOに追加

+ 下記の方法がある
    1. リリースノートに追加したのと同じように、issueをドラッグアンドドロップ
    2. 下記手順より、noteの作成
    3. 2で作成したノートをissueに変換

note追加ボタン
![image](https://cloud.githubusercontent.com/assets/16536071/19914541/c67860a2-a0ee-11e6-8ebe-3c07db9cea6c.png)

作成後イメージ
![image](https://cloud.githubusercontent.com/assets/16536071/19914617/56d9bccc-a0ef-11e6-842a-947f0b442a08.png)

#### 5. リリース時作業

1. 『TODO』を確認し、実行
2. 実行後、『TODO』のnoteを『TODO完了』にドラッグアンドドロップ
3. 『TODO』にあるノートが全てなくなったらリリース作業完了
