--Change id
local monitorid = 0
local reactorid = 1
local w1 = 18
local w2 = 10
local units = {" ","RF","%","C","mB","RF/t","mB/t"}
local rodpercent = 0

function wrapup()
mon = peripheral.wrap("monitor_"..monitorid)
reactor = peripheral.wrap("BigReactors-Reactor_"..reactorid)
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

function check()
monitorx, monitory = mon.getSize()
if monitorx ~= 39 or monitory ~= 19 then
	error("Monitor is the wrong size! Needs to be 4x3.") 
	elseif not reactor.getConnected() then
	error("Incorrect reactor")
	end
end

function checkstatus()
rodpercent = math.floor(energys/10000000*100)
reactor.setAllControlRodLevels(rodpercent)
if active then status="Active"
	else status="Inactive"
	end
end

function rjust1(s)
  local pad=w1-#s
  return string.rep(" ",pad) .. s
end
function rjust2(s)
  local pad=w2-#s
  return string.rep(" ",pad) .. s
end
function newline()
x, y = mon.getCursorPos()
mon.setCursorPos(1,y+1)
--[[term.redirect(mon)
print("")
term.redirect(term.native)]]
mon.setTextColor(colors.white)
end
function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
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
print(status)
mon.clear()
mon.setCursorPos(1,1)
mon.write("Reactor control         Day "..os.day()..", "..textutils.formatTime(os.time(), true))
newline()
printstatus()
printcolor("Reactor Energy",energys,10000000,units[2])
printcolor("Temperature",temp,-2000,units[4])
printnocolor("Rod insertion",energyp,units[3])
printnocolor("Energy Produced",energyp,units[6])
printnocolor("Fuel consumed",fuelc,units[7])
printnocolor("Fuel amount",fuel,units[5]) 
printnocolor("Waste amount",waste,units[5])
sleep(5)
end
