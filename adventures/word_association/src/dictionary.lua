 ------------------
--- Dependencies ---
 ------------------

module("dictionary", package.seeall)


 ----------------
---  Functions ---
 ----------------

addWord = function(self, pWord)
  if pWord then
    self.data[pWord] = self.data[pWord] or {meaning=MES_NIL, link={}}
  end
end

linkList = function(self, pWord)
  local result  = {}
  for link, value in pairs(self.data[pWord].link) do
    table.insert(result, link)
  end
  table.sort(result)
  return result
end

linkWords = function(self, pFrom, pTo)
  self:addWord(pFrom)
  self:addWord(pTo)
  if pFrom and pTo then
    self.data[pFrom].link[pTo] = (self.data[pFrom].link[pTo] or 0) + 1
    self.data[pTo].link[pFrom] = (self.data[pTo].link[pFrom] or 0) + 1
  end
end

randomWord = function(self)
  local words = self:wordList()
  if 0 < #words then return words[math.random(#words)] end
  return nil
end

setMeaning = function(self, pWord, pMeaning)
  self:addWord(pWord)
  self.data[pWord].meaning = pMeaning
end

wordList = function(self)
  local result  = {}
  for word, value in pairs(self.data) do
    table.insert(result, word)
  end
  table.sort(result)
  return result
end


 ---------------------
---  Initialization ---
 ---------------------

new = function(pData)
  local data   = pData or {}
  local result = {
    data=data,
	addWord=addWord, linkList=linkList, linkWords=linkWords,
	randomWord=randomWord, setMeaning=setMeaning, wordList=wordList
  }
  return result
end
