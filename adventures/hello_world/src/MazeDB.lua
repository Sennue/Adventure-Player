require("sqlite3")

MazeDB            = {}
MazeDB_mt         = {}
MazeDB_mt.__index = MazeDB

function MazeDB:new(pUserDB, pQuestDB)
  local result = {
    userDB  = pUserDB,
    questDB = pQuestDB
  }
  setmetatable(result, MazeDB_mt)
  return result
end

function MazeDB:getUserDB()
  return self.userDB
end

function MazeDB:getQuestDB()
  return self.questDB
end

function MazeDB:getRoomName(pLocation)
  local stmt = self.questDB:prepare[[
    SELECT name FROM room_list WHERE ? = area AND ? = floor AND ? = room
  ]]
  stmt:bind( pLocation.area, pLocation.floor, pLocation.room )
  return stmt:first_cols()
end

function MazeDB:getRoomDesc(pLocation)
  local stmt = self.questDB:prepare[[
    SELECT desc FROM room_list WHERE ? = area AND ? = floor AND ? = room
  ]]
  stmt:bind( pLocation.area, pLocation.floor, pLocation.room )
  return stmt:first_cols()
end

function MazeDB:getPortalList(pLocation)
  local result = {}
  local stmt = self.userDB:prepare[[
    SELECT to_area, to_floor, to_room FROM link_list
    WHERE ? = from_area AND ? = from_floor AND ? = from_room
  ]]
  stmt:bind( pLocation.area, pLocation.floor, pLocation.room )
  for row in stmt:rows() do
    local location = {area = row.to_area, floor = row.to_floor, room = row.to_room}
    table.insert(result, location)
  end
  return result
end

function MazeDB:getLinkToRoom(pArea, pFloor, pRoom, pLinkFrom, pLinkTo, pCount)
  local roomList   = {}
  local returnList = {}
  local count      = pCount
  local stmt = self.questDB:prepare[[
    SELECT room FROM room_list WHERE ? = area AND ? = floor AND ? <= room AND room <= ?
  ]]
  local linkTo = pLinkTo
  if 0 == linkTo then linkTo = pRoom - 1 end
  stmt:bind(pArea, pFloor, pLinkFrom, linkTo)
  for row in stmt:rows() do
    table.insert(roomList, row.room)
  end
  while 0 < count and 0 < #roomList do
    local index = math.random(#roomList)
    table.insert(returnList, roomList[index])
    table.remove(roomList, index)
    count = count - 1
  end
  return returnList
end

function MazeDB:linkArea(pArea, pFloor)
  local drop_stmt = self.userDB:prepare[[
    DELETE FROM link_list WHERE ? = from_area AND ? = from_floor
  ]]
  drop_stmt:bind(pArea, pFloor):exec()

  local link_stmt = self.userDB:prepare[[
    INSERT INTO link_list (from_area, from_floor, from_room, to_area, to_floor, to_room)
    VALUES (?, ?, ?, ?, ?, ?)
  ]]

  local select_stmt
  select_stmt = self.questDB:prepare[[
    SELECT
      room_list.room      as room,
      link_list.link_from as link_from,
      link_list.link_to   as link_to,
      link_set.count      as count,
      link_set.two_way    as two_way
    FROM room_list
      LEFT JOIN link_set  ON room_list.link = link_set.set_id
      LEFT JOIN link_list ON link_set.key   = link_list.key
    WHERE ? = room_list.area AND ? = room_list.floor AND 0 < link_list.link_from
  ]]
  for row in select_stmt:bind(pArea, pFloor):rows() do
    local link_from = row.room
    local link_to_list =
      self:getLinkToRoom(pArea, pFloor, row.room, row.link_from, row.link_to, row.count)
    for k, link_to in pairs(link_to_list) do
      link_stmt:bind(pArea, pFloor, link_from, pArea, pFloor, link_to):exec()
      if 0 < row.two_way then
        link_stmt:bind(pArea, pFloor, link_to, pArea, pFloor, link_from):exec()
      end
    end
  end

  select_stmt = self.questDB:prepare[[
    SELECT
      room_list.room    as from_room,
      portal_list.area  as to_area,
      portal_list.floor as to_floor,
      portal_list.room  as to_room
    FROM room_list
      LEFT JOIN portal_set  ON room_list.portal = portal_set.set_id
      LEFT JOIN portal_list ON portal_set.key   = portal_list.key
    WHERE ? = room_list.area AND ? = room_list.floor AND 0 < room_list.portal
  ]]
  for row in select_stmt:bind(pArea, pFloor):rows() do
    link_stmt:bind(pArea, pFloor, row.from_room, row.to_area, row.to_floor, row.to_room):exec()
  end
end

function MazeDB:linkWorld()
  self.userDB:exec[[
    DROP TABLE IF EXISTS link_list;
    CREATE TABLE link_list (
      key INTEGER PRIMARY KEY,
      from_area  INTEGER,
      from_floor INTEGER,
      from_room  INTEGER,
      to_area    INTEGER,
      to_floor   INTEGER,
      to_room    INTEGER
    );
  ]]
  for row in self.questDB:rows("SELECT DISTINCT area, floor FROM room_list") do
    self:linkArea(row.area, row.floor)
  end
end

module("MazeDB")

