--Change id
local reactorids = {1}
local monitorids = {2}

local reactors = {}
local monitors = {}
local w1 = 7
local w2 = 9
local units = {" ","RF","%","C","mB","RF/t","mB/t"}

--Main functions
function wrapup()
for i,j in pairs(reactorids) do
  reactors[i] = {}
  reactors[i]["wrap"] = peripheral.wrap("BigReactors-Reactor_"..j)
  print(i..":"..j)
  end
for i,j in pairs(monitorids) do
  monitors[i] = peripheral.wrap("monitor_"..j)
  print(i..":"..j)
  end
end
 
function getinfo()
for i,j in pairs(reactors) do
  Creactor = reactors[i]["wrap"]
  reactors[i]["active"] = Creactor.getActive()
  reactors[i]["fuel"] = Creactor.getFuelAmount()
  reactors[i]["fuelc"] = Creactor.getFuelConsumedLastTick()
  reactors[i]["waste"] = Creactor.getWasteAmount()
  reactors[i]["temp"] = Creactor.getFuelTemperature()
  reactors[i]["energys"] = Creactor.getEnergyStored()
  reactors[i]["energyp"] = Creactor.getEnergyProducedLastTick()
  --reactors[i]["rodpercent"] = 0
  --reactors[i]["status"] = ""
  end
end

function checkstatus()
for i,j in pairs(reactors) do
  reactors[i]["rodpercent"] = math.floor(reactors[i]["energys"]/10000000*100)
  reactors[i]["wrap"].setAllControlRodLevels(reactors[i]["rodpercent"])
  
  end  
end

function printstatus(status)
newline()
mon.write(rjust1("Status")..": ")
if status then 
    mon.setTextColor(colors.green)
    mon.write(rjust2("Active"))
  else 
    mon.setTextColor(colors.red)
    mon.write(rjust2("Inactive"))
  end  
newline()
end

--Some pretty functions
function newline()
x, y = mon.getCursorPos()
mon.setCursorPos(1,y+1)
mon.setTextColor(colors.white)
end
function rjust1(s)
  local pad=w1-#s
  return string.rep(" ",pad) .. s
end
function rjust2(s)
  local pad=w2-#s
  return string.rep(" ",pad) .. s
end
function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

--Modifyed print
function printnocolor(name,value,unit)
mon.write(rjust1(name)..":"..rjust2(tostring(round(value,3))).." "..unit)
newline()
end
function printcolor(name,value,maxvalue,unit)
mon.write(rjust1(name)..":")
local percent = math.floor(value/math.abs(maxvalue)*100)
if maxvalue>0 then
  if percent > 66 then mon.setTextColor(colors.green)
    elseif percent < 34 then mon.setTextColor(colors.red)
    else mon.setTextColor(colors.yellow)
    end
  else
  if percent > 66 then mon.setTextColor(colors.red)
    elseif percent < 34 then mon.setTextColor(colors.green)
    else mon.setTextColor(colors.yellow)
    end
  end
mon.write(rjust2(tostring(round(value,3))).." "..unit)
newline()
end

function fuelRodLevel(rodLevel,m)
  local posx = 28
  local posy = 3
  m.setBackgroundColor(colors.gray)
  m.setCursorPos(posx,posy)
  m.write("       ")
  m.setCursorPos(posx+2,posy)
  m.write(tostring(rodLevel).."%")
  for i = 1,10 do
    m.setCursorPos(posx,posy+i)
    m.setBackgroundColor(colors.gray)
    m.write(" ")
    m.setBackgroundColor(colors.yellow)
    m.write(" ")
	  if rodLevel/10 >= i then
	    m.setBackgroundColor(colors.gray)
      else
	    m.setBackgroundColor(colors.yellow)
      end
	  m.write("   ")
	  m.setBackgroundColor(colors.yellow)
	  m.write(" ")
	  m.setBackgroundColor(colors.gray)
	  m.write(" ")
    end
  m.setCursorPos(posx,posy+11)
  m.write("       ")
  m.setBackgroundColor(colors.black)
end

--Program starts here
wrapup()
while true do	
getinfo()
checkstatus()
--print(status.." "..rodpercent)
for i,j in pairs(monitors) do 
  mon = j
  reactor = reactors[i]
  mon.clear()
  mon.setCursorPos(1,1)
  mon.write("Reactor control         Day "..os.day()..", "..textutils.formatTime(os.time(), true))
  newline() 
  printstatus(reactor["active"])
  printcolor("RF:",reactor["energys"],10000000,"RF")
  printcolor("Temp",reactor["temp"],-2000,"C")
  printnocolor("Rods",reactor["rodpercent"],"%")
  printnocolor("RF Gen",reactor["energyp"],"RF/t")
  printnocolor("Fuel/t",reactor["fuelc"],"mB/t")
  fuelRodLevel(reactor["rodpercent"],mon)
  end
sleep(5)
end
