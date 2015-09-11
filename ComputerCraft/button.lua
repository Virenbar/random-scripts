--[[
Modefied version of Direwolf20`s button API
http://pastebin.com/cK9wnj7X
]]
local mon = peripheral.wrap("right")
local button = {}
mon.setTextScale(1)
mon.setTextColor(colors.white)
mon.setBackgroundColor(colors.black)
               
function setTable(name, func, arg, xmin, xmax, ymin, ymax)
  button[name] = {}
  button[name]["func"] = func
  button[name]["active"] = false
  button[name]["arg"] = arg
  button[name]["xmin"] = xmin
  button[name]["ymin"] = ymin
  button[name]["xmax"] = xmax
  button[name]["ymax"] = ymax
end
--[[
function funcName()
  print("You clicked buttonText")
end
        
function fillTable()
  setTable("ButtonText", funcName, 5, 25, 4, 8)
end     
]]
function clearTable()
  button = {}
end
     
function screen()
  local BColor
  for name,data in pairs(button) do
    if data["active"] == true then BColor = colors.lime else BColor = colors.red end
    mon.setBackgroundColor(BColor)
    local yspot = math.floor((data["ymin"] + data["ymax"]) /2)
    local xspot = math.floor((data["xmax"] - data["xmin"] - string.len(name)) /2) +1
    for j = data["ymin"], data["ymax"] do
      mon.setCursorPos(data["xmin"], j)
      if j == yspot then
        for k = 0, data["xmax"] - data["xmin"] - string.len(name) +1 do
          if k == xspot then mon.write(name) else mon.write(" ") end
        end
      else
        for i = data["xmin"], data["xmax"] do
          mon.write(" ")
        end
      end
    end
  mon.setBackgroundColor(colors.black)  
  end
end

function toggleButton(name)
  button[name]["active"] = not button[name]["active"]
  screen()
end     

function flash(name)
  toggleButton(name)
  screen()
  sleep(0.15)
  toggleButton(name)
  screen()
end
                                             
function checkxy(x, y)
  for name, data in pairs(button) do
    if y>=data["ymin"] and  y <= data["ymax"] then
      if x>=data["xmin"] and x<= data["xmax"] then
        if data["arg"] == "" then
          data["func"]()
        else
          data["func"](data["arg"])
        end
        return true
        --print(name)
      end
    end
  end
  return false
end
     
function heading(text)
  w, h = mon.getSize()
  mon.setCursorPos((w-string.len(text))/2+1, 1)
  mon.write(text)
end
     
function label(w, h, text)
  mon.setCursorPos(w, h)
  mon.write(text)
end