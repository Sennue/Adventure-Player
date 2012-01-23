module("senplayer", package.seeall)
require("sentag")

-- TODO : reset (quest spec)
-- TODO : start
-- TODO : resume
-- TODO : end
-- TODO : save (client / quest spec)
-- TODO : load (client / quest spec)

 ----------
--- Data ---
 ----------

-- public API
reset = function()
  artAlpha						= 1.0
  artFilename					= "image"
  artFiletype					= "png"
  backgroundColor				= {}
    backgroundColor.red			= 0.8
    backgroundColor.green		= 0.8
    backgroundColor.blue		= 0.8
    backgroundColor.hue			= nil
    backgroundColor.saturation	= nil
    backgroundColor.brightness	= nil
  choiceIndex					= 1
  choiceList					= {
    {
      section = "Verbal Response",
      {choice = "Yes",	quantity="", description = "Of course.",     artFilename="yes", artFiletype="png"},
      {choice = "No",	quantity="", description = "Not happening.", artFilename="no",  artFiletype="png"},
    },
  }
  choiceName					= "Yes"
  choiceSection					= 1
  done							= false
  link							= "http://www.sennue.com"
  menuAnchor					= 0 -- 0 = default ; 1 = next ; 2 = menu ; 3 = art
  musicFilename					= "song"
  musicFiletype					= "mp3"
  pageType						= "text" -- "art" ; "input" ; "choice" ; "link"
  prompt						= "OK? "
  text							= " "
  textColor						= {}
    textColor.red				= 0.0
    textColor.green				= 0.0
    textColor.blue				= 0.0
    textColor.hue				= nil
    textColor.saturation		= nil
    textColor.brightness		= nil
  input							= "input"
  inputDefault					= "default"
  inputType						= "text" -- or "number"

  -- Warm up the RNG
  math.randomseed(os.time())
  for i = 1, 5 do
    math.random()
  end
end

 -------------------------------
--- Private Utility Functions ---
 -------------------------------

local setRGB = function(pTable,pRed,pGreen,pBlue)
  pTable.red		= pRed
  pTable.green		= pGreen
  pTable.blue		= pBlue
  pTable.hue		= nil
  pTable.saturation	= nil
  pTable.brightness	= nil
end

local setHSB = function(pTable,pHue,pSaturation,pBrightness)
  pTable.hue		= pHue
  pTable.saturation	= pSaturation
  pTable.brightness	= pBrightness
  pTable.red		= nil
  pTable.green		= nil
  pTable.blue		= nil
end

local safeTag = function(pText,pParams)
  if (pText and pParams) then
    return sentag.tag(pText, pParams)
  elseif (pText) then
    return pText
  end
  -- else
  return ""
end

 --------------------------
--- Public API Functions ---
 --------------------------

addChoice = function(pChoice)
  table.insert(choiceList[#choiceList],pChoice)
end

addChoiceTagged = function(pChoice, pQuantity, pDescription, pParams)
  local choice      = safeTag(pChoice,      pParams)
  local quantity    = safeTag(pQuantity,    pParams)
  local description = safeTag(pDescription, pParams)
  table.insert(choiceList[#choiceList], {choice=choice, quantity=quantity, description=description})
end

addChoiceSection = function(pSection)
  table.insert(choiceList,pSection)
end

addNewChoiceSection = function(pSectionTitle, pParams)
  local sectionTitle = safeTag(pSectionTitle, pParams)
  table.insert(choiceList,{section=sectionTitle})
end

addText = function(pText,pParams)
  text = text .. safeTag(pText,pParams)
end

getChoice = function()
  return choiceSection, choiceIndex, choiceName
end

getChoiceIndex = function()
  return choiceIndex
end

getChoiceName = function()
  return choiceName
end

getChoiceSection = function()
  return choiceSection
end

getInput = function()
  input = sentag.sterilize(input)
  return input
end

-- quest calls this function to get data from the filesystem
-- client may call quest.load() to have a quest directly load data
-- load = function(pFilename,pSharing)
--   data = client.load(pFilename,pSharing)
--   quest.load(data)
-- end

-- client will stop updating the quest
quit = function()
  done = true
end

-- quest calls this function to put data on the filesystem
-- client may call quest.save() to have the quest push data via this function
-- save = function(pData,pFilename,pSharing)
--   client.save(pData,pFilename,pSharing)
-- end

setArt = function(pFilename,pFiletype)
  artFilename = pFilename
  artFiletype = pFiletype
end

setArtAlpha = function(pAlpha)
  artAlpha = pAlpha
end

setBackgroundColorHSB = function(pHue,pSaturation,pBrightness)
  setHSB(backgroundColor,pHue,pSaturation,pBrightness)
end

setBackgroundColorRGB = function(pRed,pGreen,pBlue)
  setRGB(backgroundColor,pRed,pGreen,pBlue)
end

setChoiceArt = function(pFilename,pFiletype,pSectionID,pChoiceID)
  local sectionID = pSectionID or #choiceList
  local choiceID  = pChoiceID  or #(choiceList[sectionID])
  choiceList[sectionID][choiceID].artFilename = pFilename
  choiceList[sectionID][choiceID].artFiletype = pFiletype
end

setChoices = function(pChoiceList)
  choiceList = pChoiceList
end

setLink = function(pLink)
  link = pLink
end

setMenuAnchor = function(pAnchor)
  local table = {1,2,3,default=1,next=1,menu=2,art=3}
  menuAnchor  = table[tostring(pAnchor):lower()] or table["default"]
end

setMusic = function(pFilename,pFiletype)
  musicFilename = pFilename
  musicFiletype = pFiletype
end

setPageType = function(pPageType)
  pageType = pPageType
end

setPrompt = function(pPrompt,pParams)
  prompt = safeTag(pPrompt, pParams)
end

setText = function(pText,pParams)
  text = safeTag(pText, pParams)
end

setTextColorHSB = function(pHue,pSaturation,pBrightness)
  setHSB(textColor,pHue,pSaturation,pBrightness)
end

setTextColorRGB = function(pRed,pGreen,pBlue)
  setRGB(textColor,pRed,pGreen,pBlue)
end

setInputDefault = function(pDefault)
  inputDefault = pDefault
end

setInputType = function(pType)
  inputType = pType
end

tagChoices = function(pParams)
  for i, v in ipairs(choiceList) do
    v.choice		= safeTag(v.choice, pParams)
    v.quantity		= safeTag(v.quantity, pParams)
    v.description	= safeTag(v.description, pParams)
  end
end

 --------------------
--- Initialization ---
 --------------------

fetchInput = function()
  -- Prompt and collect input
  coroutine.yield()
  return getInput()
end

fetchChoice = function()
  -- Prompt and collect choice
  coroutine.yield()
  return getChoice()
end

fetchChoiceIndex = function()
  -- Prompt and collect choice index
  coroutine.yield()
  return getChoiceIndex()
end

fetchChoiceName = function()
  -- Prompt and collect choice name
  coroutine.yield()
  return getChoiceName()
end

fetchChoiceSection = function()
  -- Prompt and collect choice index
  coroutine.yield()
  return getChoiceSection()
end

 --------------------
--- Initialization ---
 --------------------

reset()
