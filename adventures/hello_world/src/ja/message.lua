module("quest", package.seeall)
os.setlocale("en_US.UTF-8","all")


 ------------
-- Messages --
 ------------
MES_HELLO         = "世界よ、今日は！"
MES_BYE           = "残酷な世界よ、左様なら！"
MES_GET_NAME      = "御名前は何ですか？"
MES_GET_AGE       = "#PARAMETER(1)さんは御幾つですか？"
MES_QUIT          = "#PARAMETER(1)さん、左様なら。#PARAMETER(1)さんは#PARAMETER(2)歳ですね。恐怖と言えば「#PARAMETER(3)」です。"
MES_MENU_FEAR     = "何が怖いですか？"
MES_SEC_FEAR      = "回避不可"
MES_ACT_SPEAKING  = "演説"
MES_DES_SPEAKING  = "#PARAMETER(1)さんを虐めたい人が沢山居いそうです。"
MES_ACT_DEATH     = "死亡"
MES_DES_DEATH     = "#PARAMETER(2)歳の人でも死んでしまいますよ。"
MES_ACT_TAXES     = "税金"
MES_DES_TAXES     = "#PARAMETER(1)さんの御金が欲しいですよ。"
MES_MENU_SYSTEM   = "システム・メニュー：何をしますか？"
MES_SEC_DEFAULT   = "デフォルト選択"
MES_ACT_CANCEL    = "キャンセル"
MES_DES_CANCEL    = "変更せずにクエストに戻ります。"
MES_SEC_DATA      = "データ"
MES_ACT_SAVE      = "セーブ"
MES_DES_SAVE      = "#PARAMETER(1)さんの進行データを保存します。"
MES_ACT_LOAD      = "ロード"
MES_DES_LOAD      = "#PARAMETER(1)さんの進行データをロードします。"
MES_SEC_SYSTEM    = "システム"
MES_ACT_QUIT      = "辞める"
MES_DES_QUIT      = "辞めて最初からやり直します。"
MES_DEBUG_INPUT   = "入力数値 = '#PARAMETER(1)'\n" ..
					"選択種番 = '#PARAMETER(2)'\n" ..
					"選択番号 = '#PARAMETER(3)'\n" ..
                    "選択名　 = '#PARAMETER(4)'\n"
MES_SAVE          = "セーブ：スロット名を入力して下さい。"
MES_SAVE_GROUP    = "セーブ：要否のグループ名です。"
MES_LOAD          = "ロード：スロットを選んで下さい。"
MES_SEC_PRIVATE   = "個人データ"
MES_SEC_SHARED    = "「#PARAMETER(1)」共有データ"
MES_SEC_RESPONSE  = "行動選択"
MES_ACT_YES       = "はい"
MES_ACT_NO        = "いいえ"
MES_DES_YES_GROUP = "新しい共有データグループを作りたいです。"
MES_DES_NO_GROUP  = "個人データを使いたいです。"
MES_SEC_GROUPS    = "共有データグループ一覧"
MES_NIL           = ""
MES_GET_GROUP     = "共有データグループを使いたいですか？"


 ------------------
-- Default Values --
 ------------------
DEFAULT_NAME = "某藤太郎"
DEFAULT_AGE  = 21
DEFAULT_SAVE = "データ"
