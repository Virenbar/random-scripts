--Change id
local reactorids = {1,2}
local monitorids = {0,1}

local reactors = {}
local monitors = {}
local w1 = 18
local w2 = 10
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
mon.write(rjust1(name)..": "..rjust2(tostring(round(value,3))).." "..unit)
newline()
end
function printcolor(name,value,maxvalue,unit)
mon.write(rjust1(name)..": ")
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

--Program starts here
wrapup()
while true do	
getinfo()
checkstatus()
--print(status.." "..rodpercent)
for i,j in pairs(monitors) do 
  mon = j
  mon.clear()
  mon.setCursorPos(1,1)
  mon.write("Reactor control         Day "..os.day()..", "..textutils.formatTime(os.time(), true))
  newline()
  for n,r in pairs(reactors) do  
    printstatus(reactors[n]["active"])
    printcolor("Reactor Energy",reactors[n]["energys"],10000000,units[2])
    printcolor("Temperature",reactors[n]["temp"],-2000,units[4])
    printnocolor("Rod insertion",reactors[n]["rodpercent"],units[3])
    printnocolor("Energy Produced",reactors[n]["energyp"],units[6])
    printnocolor("Fuel consumed",reactors[n]["fuelc"],units[7])
    printnocolor("Fuel amount",reactors[n]["fuel"],units[5]) 
    printnocolor("Waste amount",reactors[n]["waste"],units[5])
    end
  end
sleep(5)
end
