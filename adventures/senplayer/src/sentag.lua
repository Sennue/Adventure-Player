 ------------------
--- Dependencies ---
 ------------------

module("sentag", package.seeall)


 ----------
--- Data ---
 ----------

local tags
local param
local pattern


 -----------------------
--- Private Functions ---
 -----------------------

local function parameter(pString)
  local result = param[tonumber(pString) or tostring(pString)]
  if "table" == type(result) then
    result = token.parameter .. pString
  end
  return tostring(result)
end

local function split(pString, pToken)
  local result = {n=0}
  local addMatch = function(pMatch)
    result.n = result.n + 1
    result[result.n] = pMatch
  end
  local pattern = "%s*(.-)%s*" .. pToken .. "%s*"
  pString = pString .. pToken
  pString = string.gsub(pString, "^%s+", "")
  pString = string.gsub(pString, "%s+$", "")
  pString = string.gsub(pString, pattern, addMatch)
  return result
end

local function replaceTag(pString)
  local id = string.gsub(pString, pattern.tag_id, pattern.extract)
  id = string.lower(id)
  local tag_param = string.gsub(pString, pattern.tag_param, pattern.extract)
  tag_param = split(tag_param, token.split)
  for index, value in ipairs(tag_param) do
    local key = string.match(value, pattern.parameter)
    if key then
      tag_param[index] = param[tonumber(key) or string.lower(tostring(key))] or
        ""
    end
  end
  return tags[id](unpack(tag_param))
end

local function reset()
  tags = {}
  token = {
    parameter = "$",
    tag       = "#",
    split     = ";"
  }
  pattern = {
    parameter      = token.parameter .. "([%w_]+)",
    tag            = token.tag .. "[%w_]+%([^%(^%)]*%)",
    tag_id         = token.tag .. "([%w_]+)%([^%(^%)]*%)",
    tag_param      = token.tag .. "[%w_]+%(([^%(^%)]*)%)",
    extract        = "%1",
    magic_cookie   = "(["..token.parameter.."|"..token.tag.."])([%w_])",
    sterile_cookie = "%1 %2"
  }
  param = {}

  register("parameter",parameter)
end


 ----------------------
--- Public Functions ---
 ----------------------

function register(pName, pCallback)
  tags[pName] = pCallback
end

function tag(pMessage, pParam)
  param = pParam
  local result = pMessage
  repeat
    local count = 0
    result, count = string.gsub(result, pattern.tag, replaceTag)
  until 0 == count
  return result
end

function sterilize(pMessage)
  return string.gsub(pMessage, pattern.magic_cookie, pattern.sterile_cookie)
end

function print(pMessage, pParam)
  _G.print(tag(pMessage, pParam))
end

 --------------------
--- Initialization ---
 --------------------

reset()
