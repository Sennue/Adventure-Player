 ------------------
--- Dependencies ---
 ------------------

module("quest", package.seeall)
require("dictionary")


 --------------------
-- System Functions --
 --------------------

page = {}

function save(pFileName,pSharedPath)
  local data = {saveName=saveName, dictionary=myDictionary.data, lastWord=lastWord, color=color}
  -- sentag.print("SAVE : #PARAMETER(1), #PARAMETER(2), #PARAMETER(3), #PARAMETER(4)", {saveName, lastWord, color, ""})
  return senplayer.save(data, pFileName, pSharedPath)
end

function load(pData)
  local data = pData or {}
  redraw = true

  saveName     = data.saveName or DEFAULT_SAVE
  myDictionary = dictionary.new(data.dictionary)
  lastWord     = data.lastWord or nil
  color        = data.color    or 0
  color        = color - 1/12
  return true
end

function nextColor(pStep)
  local step = pStep or 1/12
  color = (color or -step) + step
  if (1.0 < color) then
    color = color - 1.0
  end
  return color
end

function setColor(pHue, pAlpha)
  local backgroundHue = (pHue or 0.0)
  local textHue       = (pHue or 0.0) + 0.5
  if (1.0 < textHue) then
    textHue = textHue - 1.0
  end
  senplayer.setTextColorHSB(textHue, 0.3, 1.0)
  senplayer.setBackgroundColorHSB(backgroundHue, 1.0, 0.3)
  senplayer.artAlpha  = (pAlpha or 1.0)
end

function updateArt(pHue, pAlpha)
  senplayer.setArt(tostring(math.random(13)), "png")
  senplayer.setMusic("music", "flac")
  setColor(pHue, pAlpha)
end

function showDictionary(pHue, pAlpha)
  updateArt(pHue, pAlpha)

  local keys  = myDictionary:wordList()
  local links = {}

  senplayer.setText(MES_NIL, {})
  for i, word in ipairs(keys) do
    links = myDictionary:linkList(word)
    senplayer.addText("#PARAMETER(1) → ", {word})
    for i, link in ipairs(links) do
	  local strength = myDictionary.data[word].link[link]
	  senplayer.addText("#PARAMETER(1)", {link})
	  if 1 < strength then
        senplayer.addText(" (#PARAMETER(1))", {strength})
	  end
	  if i < #links then
        senplayer.addText(", ", {})
      else
        senplayer.addText("\n", {})
	  end
	end
  end
end


 ---------
-- Pages --
 ---------

page.log = function(pHue, pAlpha)
  senplayer.setPageType("text")
  showDictionary(pHue, pAlpha)
end

page.play = function(pHue, pAlpha)
  senplayer.setPageType("input")
  senplayer.setInputType("text")
  senplayer.setMenuAnchor("next")
  senplayer.setInputDefault(myDictionary:randomWord() or MES_NIL)

  if not lastWord then
    senplayer.setPrompt(MES_FIRST_WORD, {})
  else
    senplayer.setPrompt(MES_NEXT_WORD, {lastWord})
  end
  showDictionary(pHue, pAlpha)

  thisWord = tostring(senplayer.fetchInput()):gsub("%s+"," "):gsub("^%s",""):gsub("%s$","")
  if menuItem or showArt then
    thisWord = MES_NIL
  end
  if 0 < #thisWord then
    myDictionary:linkWords(thisWord, lastWord)
    lastWord = thisWord
  end
end

page.menuSave = function()
  updateArt(color, 0.3)
  senplayer.setPageType("input")
  senplayer.setInputType("text")
  senplayer.setBackgroundColorHSB(0.0, 0.0, 0.0)
  senplayer.setTextColorHSB(0.0, 0.0, 1.0)

  senplayer.setText("", {})
  senplayer.setPrompt(MES_SAVE, {})
  senplayer.setInputDefault(saveName or DEFAULT_SAVE)
  saveName = senplayer.fetchInput()
  save(saveName)
  return false
end

page.menuLoad = function()
  updateArt(color, 0.3)
  senplayer.setPageType("choice")
  senplayer.setBackgroundColorHSB(0.0, 0.0, 0.0)
  senplayer.setTextColorHSB(0.0, 0.0, 1.0)

  local params = {}
  local action
  local section
  local index
  local dataList = senplayer.getFileList()
  local private  = {}

  for i,v in ipairs(dataList) do
    local fileName = string.match(v, "^" .. quest.info.id .. "%-(.+)%.plist$")
    if (fileName) then
      table.insert(private, fileName)
    end
  end

  senplayer.setPrompt(MES_LOAD)
  senplayer.setChoices({})
  senplayer.addNewChoiceSection(MES_SEC_DEFAULT, params)
  senplayer.addChoiceTagged(MES_ACT_CANCEL, "", MES_DES_CANCEL, params)
  senplayer.setChoiceArt("icon-cancel","png")

  senplayer.addNewChoiceSection(MES_SEC_DATA_SLOT, params)
  table.sort(private)
  for i,v in ipairs(private) do
    senplayer.addChoiceTagged(v, "", "", params)
    senplayer.setChoiceArt("icon-load","png")
    -- print("Private", v)
  end

  section, index, action = senplayer.fetchChoice()
  if 1 == section and MES_ACT_CANCEL == action then
    return false
  elseif 2 == section then
    senplayer.load(private[index])
  end
  redraw = false
  return false
end

page.mainMenu = function()
  updateArt(color, 0.3)
  senplayer.setPageType("choice")
  senplayer.setBackgroundColorHSB(0.0, 0.0, 0.0)
  senplayer.setTextColorHSB(0.0, 0.0, 1.0)

  local params = {name, age}
  local action

  senplayer.setPrompt(MES_MENU_SYSTEM)
  senplayer.setChoices({})
  senplayer.addNewChoiceSection(MES_SEC_DEFAULT,   params)
  senplayer.addChoiceTagged(MES_ACT_CANCEL, "", MES_DES_CANCEL, params)
  senplayer.setChoiceArt("icon-cancel","png")
  senplayer.addNewChoiceSection(MES_SEC_DATA,   params)
  senplayer.addChoiceTagged(MES_ACT_SAVE, "", MES_DES_SAVE, params)
  senplayer.setChoiceArt("icon-save","png")
  senplayer.addChoiceTagged(MES_ACT_LOAD, "", MES_DES_LOAD, params)
  senplayer.setChoiceArt("icon-load","png")
  senplayer.addNewChoiceSection(MES_SEC_SYSTEM, params)
  senplayer.addChoiceTagged(MES_ACT_RESET, "", MES_DES_RESET, params)
  senplayer.setChoiceArt("icon-reset","png")
  action = senplayer.fetchChoiceName()
  if MES_ACT_CANCEL == action then
    return false
  elseif MES_ACT_SAVE == action then
    return "menuSave"
  elseif MES_ACT_LOAD == action then
    return "menuLoad"
  elseif MES_ACT_RESET == action then
    load({})
    redraw = false
    return false
  end
end

page.art = function(pImage)
  if pImage then
    senplayer.setArt(pImage, "png")
  end
  senplayer.setPageType("art")
  senplayer.setBackgroundColorHSB(1.0, 0.0, 0.0)
  coroutine.yield()
end

function mainLoop()
  while true do
    if redraw then
      redraw = false
    elseif showArt then
      showArt  = false
      menuItem = prevMenuItem
      page.art()
    elseif menuItem then
      senplayer.setMenuAnchor("menu")
      prevMenuItem = menuItem
      menuItem = page[menuItem]()
    else
      color = nextColor()
    end
    updateArt(color, 0.3)
    if not (menuItem or showArt) then
      prevMenuItem = false
      page.play(color,0.3)
    end
  end
end

function resume()
  run()
end

function image()
  if (not showArt) then showArt = true end
  run()
end

function menu()
  showArt  = false
  menuItem = "mainMenu"
  run()
end

function reset(pData)
  load(pData)
  run = coroutine.wrap(mainLoop)
end

function start(pData)
  reset(pData)
end

function quit()
end
