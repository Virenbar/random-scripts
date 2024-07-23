CT = require "ct"
local mon = peripheral.find("monitor")
local minecraftdrama = ""

local function updateMonitor()
  while true do
    mon.clear()
    mon.setCursorPos(1, 1)
    CT.print(mon,
      "Day " ..
      os.day() .. " " .. textutils.formatTime(os.time(), true) .. " IRL: " ..
      textutils.formatTime(os.time('local'), true))
    CT.print(mon, minecraftdrama)
    sleep(1)
  end
end

local function updateDrama()
  while true do
    -- https://mc-drama.herokuapp.com/raw
    -- https://ftb-drama.virenbar.ru/txt
    -- https://mc-drama.virenbar.ru/txt
    local responce = http.get("https://mc-drama.virenbar.ru/txt")
    if responce then
      minecraftdrama = responce.readAll()
    end
    sleep(60)
  end
end

parallel.waitForAny(updateMonitor, updateDrama)
