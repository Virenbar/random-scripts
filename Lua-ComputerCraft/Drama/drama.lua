CT = require "ct"
local mon = peripheral.find("monitor")
local minecraftdrama = ""

--[[
while true do
  resp = http.get("https://mc-drama.herokuapp.com/raw")
  if resp then
    minecraftdrama = resp.readAll()
    mon.clear()
    mon.setCursorPos(1,1)
    CT.print(mon, "Day "..os.day().." "..textutils.formatTime(os.time(), true).." IRL: "..textutils.formatTime(os.time('local'), true))
    CT.print(mon, minecraftdrama)
    
  end
  sleep(60)
end
--]]

local function updateMonitor()
  while true do
    mon.clear()
    mon.setCursorPos(1,1)
    CT.print(mon, "Day "..os.day().." "..textutils.formatTime(os.time(), true).." IRL: "..textutils.formatTime(os.time('local'), true))
    CT.print(mon, minecraftdrama)
    sleep(1)
  end
end

local function updateDrama()
  while true do
    resp = http.get("https://mc-drama.herokuapp.com/raw")
    if resp then
      minecraftdrama = resp.readAll()
    end
    sleep(60)
  end
end

parallel.waitForAny(updateMonitor, updateDrama)
