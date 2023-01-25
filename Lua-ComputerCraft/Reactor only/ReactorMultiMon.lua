--Change id
local reactorid = 1
local monitorids = {0,1}

local monitors = {}
local w1 = 18
local w2 = 10
local units = {" ","RF","%","C","mB","RF/t","mB/t"}

--Main functions
function wrapup()
reactor = peripheral.wrap("BigReactors-Reactor_"..reactorid)
for i,j in pairs(monitorids) do
  monitors[i] = peripheral.wrap("monitor_"..j)
  print(i..":"..j)
  end
end

function check()
if not reactor.getConnected() then
	error("Incorrect reactor")
	end
end
 
function getinfo()
active = reactor.getActive()
fuel = reactor.getFuelAmount()
fuelc = reactor.getFuelConsumedLastTick()
temp = reactor.getFuelTemperature()
waste = reactor.getWasteAmount()
energys = reactor.getEnergyStored()
energyp = reactor.getEnergyProducedLastTick()
end

function checkstatus()
rodpercent = math.floor(energys/10000000*100)
reactor.setAllControlRodLevels(rodpercent)
if active then status="Active"
	else status="Inactive"
	end
end

function printstatus()
newline()
mon.write(rjust1("Status")..": ")
if status == "Active" then
	mon.setTextColor(colors.green)
	else mon.setTextColor(colors.red)
	end
mon.write(rjust2(status))
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
check()
while true do	
getinfo()
checkstatus()
print(status.." "..rodpercent)
for i,j in pairs(monitors) do 
  mon = j
  mon.clear()
  mon.setCursorPos(1,1)
  mon.write("Reactor control         Day "..os.day()..", "..textutils.formatTime(os.time(), true))
  newline()
  printstatus()
  printcolor("Reactor Energy",energys,10000000,units[2])
  printcolor("Temperature",temp,-2000,units[4])
  printnocolor("Rod insertion",rodpercent,units[3])
  printnocolor("Energy Produced",energyp,units[6])
  printnocolor("Fuel consumed",fuelc,units[7])
  printnocolor("Fuel amount",fuel,units[5]) 
  printnocolor("Waste amount",waste,units[5])
  end
sleep(5)
end
