module("quest", package.seeall)
os.setlocale("en_US.UTF-8","all")


 ------------
-- Messages --
 ------------
MES_FIRST_WORD    = "最初に思い付いた単語を入力して下さい。"
MES_NEXT_WORD     = "#PROPER(#PARAMETER(1))。次に思い付く単語は何ですか？"

MES_MENU_SYSTEM   = "システム・メニュー：何をしますか？"
MES_SEC_DEFAULT   = "デフォルト選択"
MES_ACT_CANCEL    = "キャンセル"
MES_DES_CANCEL    = "変更せずにクエストに戻ります。"
MES_SEC_DATA      = "データ"
MES_ACT_SAVE      = "セーブ"
MES_DES_SAVE      = "進行データを保存します。"
MES_ACT_LOAD      = "ロード"
MES_DES_LOAD      = "進行データをロードします。"
MES_SEC_SYSTEM    = "システム"
MES_ACT_RESET     = "リセット"
MES_DES_RESET     = "単語歴史を消して最初からやり直します。"
MES_SAVE          = "セーブ：スロット名を入力して下さい。"
MES_LOAD          = "ロード：スロットを選んで下さい。"
MES_SEC_DATA_SLOT = "データスロット"
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
DEFAULT_SAVE = "データ"
