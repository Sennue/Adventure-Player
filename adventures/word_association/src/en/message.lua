module("quest", package.seeall)
os.setlocale("en_US.UTF-8","all")


 ------------
-- Messages --
 ------------
MES_FIRST_WORD    = "Please enter the first word that comes to mind."
MES_NEXT_WORD     = "#PROPER(#PARAMETER(1)).  What does this word make you think of?"

MES_MENU_SYSTEM   = "System Menu - What will you do?"
MES_SEC_DEFAULT   = "Default Selection"
MES_ACT_CANCEL    = "Cancel"
MES_DES_CANCEL    = "Return to game.  Do not change a thing."
MES_SEC_DATA      = "Data"
MES_ACT_SAVE      = "Save"
MES_DES_SAVE      = "Save your game."
MES_ACT_LOAD      = "Load"
MES_DES_LOAD      = "Load your game."
MES_SEC_SYSTEM    = "System"
MES_ACT_RESET     = "Reset"
MES_DES_RESET     = "Clear all words and start over."
MES_SAVE          = "Save Progress : Enter slot name."
MES_LOAD          = "Load Progress : Select a slot."
MES_SEC_DATA_SLOT = "Data Slots"
MES_SEC_RESPONSE  = "Select Action"
MES_ACT_YES       = "Yes"
MES_ACT_NO        = "No"
MES_DES_YES_GROUP = "I want to use a new group."
MES_DES_NO_GROUP  = "I want to use private data."
MES_SEC_GROUPS    = "Group List"
MES_NIL           = ""
MES_GET_GROUP     = "Do you want to use a shard group?"

 ------------------
-- Default Values --
 ------------------
DEFAULT_SAVE = "data"
