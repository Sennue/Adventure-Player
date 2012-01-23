 ------------------
--- Dependencies ---
 ------------------

module("quest.tag", package.seeall)
require("sentag")


 -----------------------
--- Private Functions ---
 -----------------------

--  define your tag funtions here and register them below, in init

local function x(pString)
  return tostring(tonumber(pString))
end

local function zero_switch(pZero, pNonZero, pCount)
  local result = ""
  if 0 == tonumber(pCount) then
    result = pZero
  else
    result = pNonZero
  end
  return result
end

local function repeat_tag(pString, pRepeat)
  local result = (0 < tonumber(pRepeat)) and pString or ""
  for i = 2,pRepeat do
    result = result .. " " .. pString
  end
  return result
end

local function nouns(pSingle, pPlural, pCount)
  local result = ""
  if 1 == tonumber(pCount) then
    result = pSingle
  else
    result = pPlural
  end
  return result
end

local function x_nouns(pArticle, pSingle, pPlural, pCount)
  local count = tonumber(pCount)
  local result = ""
  if 0 == count then
    result = "no " .. pPlural
  elseif 1 == count then
    result = pArticle .. " " .. pSingle
  else
    result = pCount .. " " .. pPlural
  end
  return result
end

local function upper(pString)
  return string.upper(pString)
end

local function lower(pString)
  return string.lower(pString)
end

local function proper(pString)
  return string.gsub(pString, "%w+",
    function (pS) return string.upper(string.sub(pS,1,1)) ..
      string.lower(string.sub(pS,2)) end
  )
end

local function element(pString)
  local ele = {"fire","metal","earth","water","wood","rainbow","random","none"}
  local index = tonumber(pString)
  if index < 1 or #ele < index then
    index = #ele
  end
  return ele[index]
end

local function user()
  -- presumably this returns a user defined name
  return "wizard Merlin"
end

local function init()
  sentag.register("x",x)
  sentag.register("zero_switch",zero_switch)
  sentag.register("repeat",repeat_tag)
  sentag.register("nouns",nouns)
  sentag.register("x_nouns",x_nouns)
  sentag.register("upper",upper)
  sentag.register("lower",lower)
  sentag.register("proper",proper)
  sentag.register("element",element)
  sentag.register("user",user)
end


 --------------------
--- Initialization ---
 --------------------

init()
