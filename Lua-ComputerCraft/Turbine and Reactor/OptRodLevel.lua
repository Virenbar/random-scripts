local tArgs = { ... }
local TurC =  1
if not (tArgs == nil) then
  TurC = tonumber(tArgs[1])
end
local posx = 3
local posy = 15

function wrapup()
  mon = peripheral.find("monitor")
  reactor = peripheral.find("BigReactors-Reactor")
end

function findOptFuelRods()
  reactor.setActive(false)
  while (reactor.getFuelTemperature() > 98) or (reactor.getHotFluidAmount() > 10000) do  
    mon.clear()
    monprint(posx,posy,"Finding Optimal Rod Level")
    monprint(posx,posy+1,"Core Temp: "..round(reactor.getFuelTemperature(),3))
    monprint(posx,posy+2,"Fluid Amount: "..comma_value(reactor.getHotFluidAmount()).."mb")
    monprint(posx,posy+3,"Waiting for Shut-down")
    sleep(1)
  end
  reactor.setAllControlRodLevels(99)
  reactor.setActive(true)
  while reactor.getFuelTemperature() < 100 do
    mon.clear()
    monprint(posx,posy,"Set all rod levels to 99")
    monprint(posx,posy+1,"Core Temp: "..round(reactor.getFuelTemperature(),3))
    monprint(posx,posy+2,"Waiting for Steam")
    sleep(1)
  end
  for i=10,1,-1 do
    mon.clear()
    tempMB = reactor.getEnergyProducedLastTick()
    monprint(posx,posy,"mB/t: "..tempMB)
    monprint(posx,posy+1,"Waiting 10 seconds..."..i)
    sleep(1)
  end
  local tempMB = reactor.getEnergyProducedLastTick()
  local tempRodLevels = math.floor((TurC*2000)/tempMB)
  print((TurC*2000).."/"..tempMB.." = "..tempRodLevels)
  tempRodLevels = 100-tempRodLevels
  reactor.setAllControlRodLevels(math.floor(tempRodLevels))
  for i=5,1,-1 do
    mon.clear()
    monprint(posx,posy,"Estimated Level: "..tempRodLevels)
    monprint(posx,posy+1,"Waiting 5 seconds: "..i)
    sleep(1)
  end
  tempMB = reactor.getEnergyProducedLastTick()
  print(tempMB)
  while tempMB > (TurC*2000) do
	  mon.clear()
    tempRodLevels = tempRodLevels+1
	  reactor.setAllControlRodLevels(math.floor(tempRodLevels))
	  mon.clear()
    monprint(posx,posy,"Setting Rod Levels to: "..tempRodLevels)
    monprint(posx,posy+1,"Getting below "..(TurC*2000).."mB/t")
	  monprint(posx,posy+2,"Currently at: "..tempMB)
    sleep(5)
    tempMB = reactor.getEnergyProducedLastTick()
	end
  while tempMB < 2000 do
    mon.clear()
    tempRodLevels = tempRodLevels - 1
	  reactor.setAllControlRodLevels(math.floor(tempRodLevels))
	  monprint(posx,posy,"Setting Rod Levels to: "..tempRodLevels)
	  monprint(posx,posy+1,"Getting Above "..(TurC*2000).."mB/t")
	  monprint(posx,posy+2,"Currently at: "..tempMB)
    sleep(5)
    tempMB = reactor.getEnergyProducedLastTick()
  end
  mon.clear()
  monprint(posx,posy,"Optimal Rod Level: "..tempRodLevels)
  RodFile = fs.open("OptRodLevel","w") 
  RodFile.write(tempRodLevels)
  RodFile.close()
end


function monprint(x,y,text,color)
  if color == nil then
    mon.setTextColor(colors.white)
  else
    mon.setTextColor(color)
  end
  mon.setCursorPos(x,y)
  mon.write(text)
  mon.setTextColor(colors.white)
end
function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end  
function comma_value(amount)
  local formatted = amount
  while true do
    formatted, k = string.gsub(formatted, "^(%d+)(%d%d%d)", '%1,%2')
    if k == 0 then
      break
    end
  end
  return formatted
end

wrapup()
findOptFuelRods()