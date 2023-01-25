--Change id
local monitorid = 0
local reactorid = 0
local cell1id = 1
local cell2id = 2
local w1 = 18
local w2 = 10
local units = {" ","RF","%","C","mB","RF/t"}

function wrapup()
mon = peripheral.wrap("monitor_"..monitorid)
reactor = peripheral.wrap("BigReactors-Reactor_"..reactorid)
cell1 = peripheral.wrap("cofh_thermalexpansion_energycell_"..cell1id)
cell2 = peripheral.wrap("cofh_thermalexpansion_energycell_"..cell2id)
end
 
function getinfo()
active = reactor.getActive()
fuel = reactor.getFuelAmount()
temp = reactor.getFuelTemperature()
waste = reactor.getWasteAmount()
energyr = reactor.getEnergyStored()
energyp = reactor.getEnergyProducedLastTick()
--fuel = math.floor(reactor.getFuelAmount()/reactor.getFuelAmountMax()*100)
maxenergy = cell1.getMaxEnergyStored("back")
energy1 = cell1.getEnergyStored("back")
energy1p = math.floor(energy1/maxenergy*100)
energy2 = cell2.getEnergyStored("back")
energy2p = math.floor(energy2/maxenergy*100)
end

function check()
monitorx, monitory = mon.getSize()
if monitorx ~= 39 or monitory ~= 19 then
	error("Monitor is the wrong size! Needs to be 4x3.") 
	elseif not reactor.getConnected() then
	error("Incorrect reactor")
	end
end

function needenergy()
if energy1p < 34 then 
	return 1
	elseif energyr > 9500000 then 
	return 2
	else 
	return 3
	end
end

function checkstatus()
if needenergy() == 1 then
	reactor.setActive(true)
	status="Active"
	elseif needenergy() == 2 then
	reactor.setActive(false)
	status="Inactive"
	else print(status)
	end
if status == nil then
	if active then status="Active"
		else status="Inactive"
		end
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
mon.write(rjust1(name)..": "..rjust2(tostring(value)).." "..unit)
newline()
end
function printcolor(name,value,maxvalue,unit)
mon.write(rjust1(name)..": ")
local per = math.floor(value/maxvalue*100)
if per > 66 then mon.setTextColor(colors.green)
	elseif per < 34 then mon.setTextColor(colors.red)
	else mon.setTextColor(colors.yellow)
	end
mon.write(rjust2(tostring(value)).." "..unit)
newline()
end

--Program starts here
wrapup()
check()
while true do	
getinfo()
checkstatus()
print(energy1p)
mon.clear()
mon.setCursorPos(1,1)
mon.write("Reactor control         Day "..os.day()..", "..textutils.formatTime(os.time(), true))
newline()
printstatus()
printcolor("Reactor Energy",energyr,10000000,units[2])
printnocolor("Energy Produced",energyp,units[6])
printnocolor("Temperature",temp,units[4]) 
printnocolor("Fuel amount",fuel,units[5])
printnocolor("Waste amount",waste,units[5])
printcolor("Energy Cell 2",energy2,maxenergy,units[2])
printcolor("Energy Cell 1",energy1,maxenergy,units[2]) 
sleep(5)
end
