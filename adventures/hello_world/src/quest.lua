module("quest", package.seeall)
require("MazeDB")
require("sqlite3")

 --------------------
-- System Functions --
 --------------------

userDB   = sqlite3.open(senplayer.getFilePath("autosave.db"))
questDB  = sqlite3.open(senplayer.getFilePath("quest.db"))
mazeDB   = MazeDB:new(userDB, questDB)
page = {}

function save(pFileName, pSharedPath)
  local data = {
    pageItem  = pageItem,
    saveName  = saveName,
    saveGroup = saveGroup,
    name      = name,
    age       = age,
    fear      = fear,
    location  = location,
    color     = color,
  }
  -- sentag.print("SAVE : #PARAMETER(1), #PARAMETER(2), #PARAMETER(3)",
  --   {pFileName, pSharedPath, pageItem})
  return senplayer.save(data, pFileName, pSharedPath)
end

function load(pData)
  local data = pData or {}
  redraw = true

  pageItem  = data.pageItem               or 1
  saveName  = data.saveName               or DEFAULT_SAVE
  saveGroup = data.saveGroup              or ""
  name      = data.name      or name      or DEFAULT_NAME
  age       = data.age       or age       or DEFAULT_AGE
  fear      = data.fear      or fear      or MES_ACT_SPEAKING
  location  = data.location  or location  or {area = 0, floor = 1, room = 1}
  color     = data.color     or color     or 0
  color     = color - 1/12

  if 0 == location.area then
    mazeDB:linkWorld()
    location.area = 1
  end
  -- sentag.print("LOAD TABLE : #PARAMETER(1), #PARAMETER(2), #PARAMETER(3), #PARAMETER(4)", {data.name, data.age, data.fear, data.pageItem})
  -- sentag.print("LOAD FIXED : #PARAMETER(1), #PARAMETER(2), #PARAMETER(3), #PARAMETER(4)", {name, age, fear, pageItem})
  return true
end

function nextColor()
  color = (color or -1/12) + 1/12
  if (1.0 < color) then color = color - 1.0 end
  return color
end

function setColor(pHue, pAlpha)
  local backgroundHue = (pHue or 0.0)
  local textHue       = (pHue or 0.0) + 0.5
  if (1.0 < textHue) then textHue = textHue - 1.0 end
  senplayer.setTextColorHSB(textHue, 0.3, 1.0)
  senplayer.setBackgroundColorHSB(backgroundHue, 1.0, 0.3)
  senplayer.artAlpha  = (pAlpha or 1.0)

  -- senplayer.setTextColorRGB(0,0,0)
  -- senplayer.setBackgroundColorRGB(0,0,0)
  -- senplayer.artAlpha  = 0.0
end

function getMessageDB(pMessage)
  local stmt = questDB:prepare[[
    SELECT message.en AS message FROM message WHERE ? = key
  ]]
  return stmt:bind( pMessage ):first_cols()
end

function getRoomText(pLocation)
  local name = getMessageDB(mazeDB:getRoomName(pLocation))
  local desc = getMessageDB(mazeDB:getRoomDesc(pLocation))
  return name, desc
end

page.maze  = function(pHue, pAlpha)
  senplayer.setPageType("choice")
  senplayer.setArt("input", "png")
  senplayer.setMusic("hello", "flac")
  setColor(pHue, pAlpha)

  local section, index

  repeat
    local name, desc = getRoomText(location)
    local portalList = mazeDB:getPortalList(location)
    local params = {}

    senplayer.setPrompt(getMessageDB("GAME_INFO_WHERE_TO"))
    senplayer.setChoices({})
    senplayer.addNewChoiceSection(MES_SEC_DEFAULT, params)
    senplayer.addChoiceTagged(name, "", desc, params)
    senplayer.addNewChoiceSection(getMessageDB("GAME_INFO_LOCATION"), params)
    for key, portalLocation in pairs(portalList) do
      name, desc = getRoomText(portalLocation)
      senplayer.addChoiceTagged(name, "", desc, params)
    end
    senplayer.addNewChoiceSection(MES_ACT_QUIT, params)
    senplayer.addChoiceTagged(MES_ACT_QUIT, "", MES_DES_QUIT, params)
    senplayer.addNewChoiceSection("???", params)
    senplayer.addChoiceTagged("???", "", "", params)
    section, index = senplayer.fetchChoice()
    if 2 == section then
      location = portalList[index]
    end
    if 4 == section then
      mazeDB:linkWorld()
    end
  until section == 3
end

page.hello = function(pHue, pAlpha)
  senplayer.setPageType("text")
  senplayer.setArt("hello", "png")
  senplayer.setMusic("hello", "flac")
  setColor(pHue, pAlpha)

  senplayer.setText(MES_HELLO, {})
  coroutine.yield()
end

page.nameInput = function(pHue, pAlpha)
  senplayer.setPageType("input")
  senplayer.setArt("input", "png")
  senplayer.setMusic("hello", "flac")
  setColor(pHue, pAlpha)

  senplayer.setText(MES_DEBUG_INPUT, {senplayer.input, senplayer.choiceSection, senplayer.choiceIndex, senplayer.choiceName})
  senplayer.setPrompt(MES_GET_NAME, {})
  senplayer.setInputDefault(name or DEFAULT_AGE)
  senplayer.setInputType("text")
  name = senplayer.fetchInput()
end

page.ageInput = function(pHue, pAlpha)
  senplayer.setPageType("input")
  senplayer.setArt("input", "png")
  senplayer.setMusic("hello", "flac")
  setColor(pHue, pAlpha)

  senplayer.setText(MES_DEBUG_INPUT, {senplayer.input, senplayer.choiceSection, senplayer.choiceIndex, senplayer.choiceName})
  senplayer.setPrompt(MES_GET_AGE, {name})
  senplayer.setInputDefault(age or DEFAULT_AGE)
  senplayer.setInputType("number")
  age = senplayer.fetchInput()
end

page.fearChoice = function(pHue, pAlpha)
  senplayer.setPageType("choice")
  senplayer.setArt("input", "png")
  senplayer.setMusic("hello", "flac")
  setColor(pHue, pAlpha)

  local params = {name, age, fear}

  senplayer.setPrompt(MES_MENU_FEAR)
  senplayer.setChoices({})
  senplayer.addNewChoiceSection(MES_SEC_DEFAULT, params)
  senplayer.addChoiceTagged(MES_ACT_SPEAKING, "", MES_DES_SPEAKING, params)
  senplayer.addNewChoiceSection(MES_SEC_FEAR,    params)
  senplayer.addChoiceTagged(MES_ACT_DEATH, "", MES_DES_DEATH, params)
  senplayer.addChoiceTagged(MES_ACT_TAXES, "", MES_DES_TAXES, params)
  fear = senplayer.fetchChoiceName()
end


page.bye = function(pHue, pAlpha)
  senplayer.setPageType("text")
  senplayer.setArt("hello", "png")
  senplayer.setMusic("hello", "flac")
  setColor(pHue, pAlpha)

  senplayer.setText(MES_BYE, {})
  coroutine.yield()
end

page.quit = function(pHue, pAlpha)
  senplayer.setPageType("text")
  senplayer.setArt("hello", "png")
  senplayer.setMusic("hello", "flac")
  setColor(pHue, pAlpha)

  senplayer.setText(MES_QUIT, {name, age, fear})
  senplayer.quit()
  coroutine.yield()
end

page.menuSaveName = function()
  senplayer.setPageType("input")
  senplayer.setInputType("text")
  senplayer.setText("", {})

  senplayer.setPrompt(MES_SAVE, {})
  senplayer.setInputDefault(saveName or DEFAULT_SAVE)
  saveName = senplayer.fetchInput()
  return "saveUseGroup"
end

page.saveUseGroup = function()
  senplayer.setPageType("choice")

  local dataList = senplayer.getFileList()
  local params = {}
  local action
  local section
  local index
  local shared     = {}
  local sharedKeys = {}

  for i,v in ipairs(dataList) do
	local fileName
    local groupName
	groupName, fileName = string.match(v, "^shared%-(.+)%-(.+)%.plist$")
	if (fileName) then
	  if not shared[groupName] then
        table.insert(sharedKeys, groupName)
        shared[groupName] = true
      end
	end
  end

  senplayer.setPrompt(MES_GET_GROUP)
  senplayer.setChoices({})
  senplayer.addNewChoiceSection(MES_SEC_DEFAULT, params)
  senplayer.addChoiceTagged(MES_ACT_CANCEL, "", MES_DES_CANCEL, params)
  senplayer.setChoiceArt("icon","png")
  senplayer.addNewChoiceSection(MES_SEC_RESPONSE,    params)
  senplayer.addChoiceTagged(MES_ACT_NO, "", MES_DES_NO_GROUP, params)
  senplayer.addChoiceTagged(MES_ACT_YES, "", MES_DES_YES_GROUP, params)
  if 0 < #sharedKeys then
    senplayer.addNewChoiceSection(MES_SEC_GROUPS, params)
    table.sort(sharedKeys)
    for i,v in ipairs(sharedKeys) do
      senplayer.addChoiceTagged(v, "", "", params)
      senplayer.setChoiceArt("icon","png")
    end
  end

  section, index, action = senplayer.fetchChoice()
  if 1 == section and MES_ACT_CANCEL == action then
    return false
  elseif 2 == section and MES_ACT_YES == action then
    return "menuSaveGroup"
  elseif 2 == section and MES_ACT_NO == action then
    saveGroup = nil
  elseif 3 == section then
    saveGroup = sharedKeys[index]
  end
  save(saveName, saveGroup)
  return false
end

page.menuSaveGroup = function()
  senplayer.setPageType("input")
  senplayer.setInputType("text")
  senplayer.setText("", {})

  senplayer.setPrompt(MES_SAVE_GROUP, {})
  senplayer.setInputDefault(saveGroup or "")
  saveGroup = senplayer.fetchInput()
  if "" == saveGroup then saveGroup = nil end
  save(saveName, saveGroup)
  return false
end

page.menuLoad = function()
  senplayer.setPageType("choice")

  local params = {}
  local action
  local section
  local index
  local dataList = senplayer.getFileList()
  local private    = {}
  local shared     = {}
  local sharedKeys = {}
  for i,v in ipairs(dataList) do
	local fileName
    local groupName
	groupName, fileName = string.match(v, "^shared%-(.+)%-(.+)%.plist$")
	if (fileName) then
	  if not shared[groupName] then
        table.insert(sharedKeys, groupName)
        shared[groupName] = {}
      end
	  table.insert(shared[groupName], fileName)
	end
	fileName = string.match(v, "^" .. quest.info.id .. "%-(.+)%.plist$")
	if (fileName) then
      table.insert(private, fileName)
	end
  end
  
  senplayer.setPrompt(MES_LOAD)
  senplayer.setChoices({})
  senplayer.addNewChoiceSection(MES_SEC_DEFAULT, params)
  senplayer.addChoiceTagged(MES_ACT_CANCEL, "", MES_DES_CANCEL, params)
  senplayer.setChoiceArt("icon","png")
  senplayer.addNewChoiceSection(MES_SEC_PRIVATE, params)
  table.sort(private)
  for i,v in ipairs(private) do
    senplayer.addChoiceTagged(v, "", "", params)
    senplayer.setChoiceArt("icon","png")
    -- print("Private", v)
  end
  table.sort(sharedKeys)
  for i,g in ipairs(sharedKeys) do
    senplayer.addNewChoiceSection(MES_SEC_SHARED, {g})
    table.sort(shared[g])
    for i,v in ipairs(shared[g]) do
      senplayer.addChoiceTagged(v, "", "", params)
      senplayer.setChoiceArt("icon","png")
	  -- print("Shared ", v, "(" .. g .. ")")
	end
  end

  section, index, action = senplayer.fetchChoice()
  if 1 == section and MES_ACT_CANCEL == action then
    return false
  elseif 2 == section then
    senplayer.load(private[index])
  else
    local group = sharedKeys[section - 2]
    senplayer.load(shared[group][index], group)
  end
  redraw = false
  return false
end

page.mainMenu = function()
  senplayer.setPageType("choice")
  senplayer.setArt("menu", "png")
  senplayer.setArtAlpha(0.4)
  senplayer.setBackgroundColorHSB(0.0, 0.0, 0.0)
  senplayer.setTextColorHSB(0.0, 0.0, 1.0)

  local params = {name, age}
  local action

  senplayer.setPrompt(MES_MENU_SYSTEM)
  senplayer.setChoices({})
  senplayer.addNewChoiceSection(MES_SEC_DEFAULT,   params)
  senplayer.addChoiceTagged(MES_ACT_CANCEL, "", MES_DES_CANCEL, params)
  senplayer.setChoiceArt("icon","png")
  senplayer.addNewChoiceSection(MES_SEC_DATA,   params)
  senplayer.addChoiceTagged(MES_ACT_SAVE, "", MES_DES_SAVE, params)
  senplayer.addChoiceTagged(MES_ACT_LOAD, "", MES_DES_LOAD, params)
  senplayer.addNewChoiceSection(MES_SEC_SYSTEM, params)
  senplayer.addChoiceTagged(MES_ACT_QUIT, "", MES_DES_QUIT, params)
  action = senplayer.fetchChoiceName()
  if MES_ACT_CANCEL == action then
    return false
  elseif MES_ACT_SAVE == action then
    return "menuSaveName"
  elseif MES_ACT_LOAD == action then
    return "menuLoad"
  elseif MES_ACT_QUIT == action then
    load({})
	redraw = false
	return false
  end
end

page.art = function(pImage)
  if pImage then senplayer.setArt(pImage, "png") end
  senplayer.setPageType("art")
  senplayer.setBackgroundColorHSB(1.0, 0.0, 0.0)
  coroutine.yield()
end

function run()
  local pageList =
    {"hello", "nameInput", "ageInput", "fearChoice", "bye", "maze", "quit"}
  
  while true do
    if redraw then
	  redraw = false
	elseif showArt then
	  showArt = false
	  menuItem = prevMenuItem
	  page.art()
    elseif menuItem then
      senplayer.setMenuAnchor("menu")
	  prevMenuItem = menuItem
	  menuItem = page[menuItem]()
    else
      senplayer.setMenuAnchor("next")
	  pageItem = pageItem + 1
	  color = nextColor()
	  if #pageList < pageItem then pageItem = #pageList end
	end
	if not (menuItem or showArt) then
	  prevMenuItem = false
      page[pageList[pageItem]](color,0.3)
    end
  end
end

function image()
  showArt = true
  resume()
end

function menu()
  showArt = false
  menuItem = "mainMenu"
  resume()
end

function reset(pData)
  load(pData)
  resume = coroutine.wrap(run)
end

function start(pData)
  reset(pData)
end

function quit()
end

