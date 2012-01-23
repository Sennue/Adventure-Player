module("quest", package.seeall)
os.setlocale("en_US.UTF-8","all")


 ------------
-- Messages --
 ------------
MES_HELLO         = "Hello world!"
MES_BYE           = "Good-bye, cruel world!"
MES_GET_NAME      = "What is your name?"
MES_GET_AGE       = "How old are you, #PARAMETER(1)?"
MES_QUIT          = "Good-bye, #PARAMETER(1).  You are #PARAMETER(2) years old.  Your fear?  #PARAMETER(3)."
MES_MENU_FEAR     = "What do you fear more?"
MES_SEC_FEAR      = "The Unavoidable"
MES_ACT_SPEAKING  = "Public speaking"
MES_DES_SPEAKING  = "Everyone loves to laugh at #PARAMETER(1)."
MES_ACT_DEATH     = "Death"
MES_DES_DEATH     = "People die at #PARAMETER(2)."
MES_ACT_TAXES     = "Taxes"
MES_DES_TAXES     = "They want your money."
MES_MENU_SYSTEM   = "System Menu - What will you do?"
MES_SEC_DEFAULT   = "Default Selection"
MES_ACT_CANCEL    = "Cancel"
MES_DES_CANCEL    = "Just return to quest.  Do not change a thing."
MES_SEC_DATA      = "Data"
MES_ACT_SAVE      = "Save"
MES_DES_SAVE      = "Save #PARAMETER(1)'s progress."
MES_ACT_LOAD      = "Load"
MES_DES_LOAD      = "Load #PARAMETER(1)'s progress."
MES_SEC_SYSTEM    = "System"
MES_ACT_QUIT      = "Quit"
MES_DES_QUIT      = "Quit and restart."
MES_DEBUG_INPUT   = "Input Value    = '#PARAMETER(1)'\n" ..
					"Choice Section = '#PARAMETER(2)'\n" ..
					"Choice Index   = '#PARAMETER(3)'\n" ..
                    "Choice Name    = '#PARAMETER(4)'\n"
MES_SAVE          = "Save Progress : Enter slot name."
MES_SAVE_GROUP    = "Save Progress : Optional group name."
MES_LOAD          = "Load Progress : Select a slot."
MES_SEC_PRIVATE   = "Private Data"
MES_SEC_SHARED    = "'#PARAMETER(1)' Shared Data"
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
DEFAULT_NAME = "John Smith"
DEFAULT_AGE  = 21
DEFAULT_SAVE = "data"
