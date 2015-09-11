--Change settings
local padx = 9
local numTurbines = 1
local numCapacitors = 3
local turnOnAt = 30
local turnOffAt = 95
local targetSpeed = 1840
local refreshtime = 0.9
local turbineSpeed = {}
local frame = 1

local OptFuelRodLevel = 100

--Main functions
function checkFile()
  if fs.exists("OptRodLevel") then
    RodFile = fs.open("OptRodLevel","r")
    OptFuelRodLevel = RodFile.readLine()
    RodFile.close()
    else
    shell.run("OptRodLevel.lua",numTurbines)
    RodFile = fs.open("OptRodLevel","r")
    OptFuelRodLevel = RodFile.readLine()
    RodFile.close()
  end
end

function wrapup()
cap = peripheral.find("tile_blockcapacitorbank_name")
mon = peripheral.find("monitor")
reactor = peripheral.find("BigReactors-Reactor")
turbines = {peripheral.find("BigReactors-Turbine")}
numTurbines = #turbines
end
 
function getinfo()
  statusR = reactor.getActive()
  fuel = reactor.getFuelConsumedLastTick()
  temp = reactor.getFuelTemperature()
  
  energyProduction = 0
  for i,j in pairs(turbines) do
    turbineSpeed[i] = j.getRotorSpeed()
    energyProduction = energyProduction + j.getEnergyProducedLastTick()
  end
  
  energyStored = cap.getEnergyStored()
  sleep(0.1)
  energyChange = (cap.getEnergyStored()-energyStored)/3
  --print(energyChange)
  energyChange = energyChange*numCapacitors
  energyStored = cap.getEnergyStored()*numCapacitors
  energyMax = cap.getMaxEnergyStored()*numCapacitors
end

function checkstatus()
  --Energy required?
  if (energyStored/energyMax)*100 < turnOnAt then
    for _,j in pairs(turbines) do
      j.setInductorEngaged(true)
      statusT = true
    end
  end  
  if (energyStored/energyMax)*100 > turnOffAt then
    for _,j in pairs(turbines) do
      j.setInductorEngaged(false)
      statusT = false
    end
  end
  --Minimal rotor speed
  minTurbineSpeed = 10000
  maxTurbineSpeed = 0
  for _,j in pairs(turbineSpeed) do
    if j < minTurbineSpeed then
      minTurbineSpeed = j
    end
    if j > maxTurbineSpeed then
      maxTurbineSpeed = j
    end
  end
  --Need more speed?
  if maxTurbineSpeed < targetSpeed-10 then
    reactor.setActive(true)
    statusR = true
  end
  if minTurbineSpeed > targetSpeed then
    reactor.setActive(false)
    statusR = false
  end
end

--Some pretty functions
function drawline(lenght,color)
  mon.setBackgroundColor(color)
  mon.write(string.rep(" ",lenght))
end
function draw2colorline(array,color1,color2)
  for i=1,#array do
    if i % 2 == 0 then 
      drawline(array[i],color2)
    else
      drawline(array[i],color1)
    end
  end
end
function drawbox(posx,posy,color,widht,height)
  for i = 1,height do
    mon.setCursorPos(posx,posy+i-1)
    drawline(widht,color)
  end
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
function setframe(numframe)
  if frame == numframe then
    frame = 1
  else
    frame = frame + 1
  end
end

--Displaying info
function drawStatus(posx,posy,text,status)
  mon.setCursorPos(posx,posy)
  mon.write(text..": ")
  mon.setCursorPos(posx+padx,posy)
  if status then 
    mon.setTextColor(colors.green)
    mon.write("Active")
  else 
    mon.setTextColor(colors.red)
    mon.write("Inactive")
  end
  mon.setTextColor(colors.white)
end

function turbineInductorDisplay(posx,posy,status)
  local coilColor = colors.red
  if status then
	  coilColor = colors.blue
	end
  mon.setCursorPos(posx,posy)
  drawline(7,colors.gray)
  for i = 1,7 do
    mon.setCursorPos(posx,posy+i)
    drawline(1,colors.gray)
	  if i % 2 == 0 then
      draw2colorline({1,3,1},colors.lightGray,colors.gray)
    else
      draw2colorline({2,1,2},colors.lightGray,colors.gray)
	  end
    drawline(1,colors.gray)
  end
  for i = 8,10 do
    mon.setCursorPos(posx,posy+i)
	  drawline(1,colors.gray)
    drawline(1,colors.lightGray)
    drawline(1,coilColor)
    drawline(1,colors.gray)
    drawline(1,coilColor)
    drawline(1,colors.lightGray)
    drawline(1,colors.gray)
  end
  mon.setCursorPos(posx,posy+11)
  drawline(7,colors.gray)
  mon.setBackgroundColor(colors.black)
end

function verticalBar(posx,posy,height,percent)
  local widht = 3
  if percent >=75 then barColor = colors.green
  elseif percent>=50 then barColor = colors.yellow
  else barColor = colors.red
  end
  emptyHeight = math.floor((1-percent/100)*(height-2))
  mon.setCursorPos(posx,posy)
	drawline(2+widht,colors.gray)
  --print(emptyHeight)
  for i=1,height-2 do
    mon.setCursorPos(posx,posy+i)
    if emptyHeight >=i then 
      drawline(1,colors.gray)
      drawline(widht,colors.black)
      drawline(1,colors.gray)
    else
      drawline(1,colors.gray)
      drawline(widht,barColor)
      drawline(1,colors.gray)
    end
  end
  mon.setCursorPos(posx,posy+height-1)
	drawline(2+widht,colors.gray)
  mon.setCursorPos(posx+1,posy+height-1)
  mon.write(math.floor(percent).."%")
  mon.setBackgroundColor(colors.black)
end

function drawNoColor(posx,posy,name,value,unit)
  mon.setCursorPos(posx,posy)
  mon.write(name..":")
  mon.setCursorPos(posx+padx,posy)
  mon.write(tostring(round(value,2)).." "..unit)
end

function drawColor(posx,posy,name,value,maxvalue,unit)
  mon.setCursorPos(posx,posy)
  mon.write(name..":")
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
  mon.setCursorPos(posx+padx,posy)
  mon.write(tostring(round(value,2)).." "..unit)
  mon.setTextColor(colors.white)
end


--Program starts here
wrapup()
checkFile()
reactor.setAllControlRodLevels(tonumber(OptFuelRodLevel))
while true do	
getinfo()
checkstatus()
mon.clear()
mon.setCursorPos(1,1)
mon.write("Day "..os.day()..", "..textutils.formatTime(os.time(), true))

verticalBar(1,3,22,(energyStored/energyMax)*100)
turbineInductorDisplay(20,13,statusT)
drawColor(7,3,"Yield",energyChange,100,"RF/t")--Change

drawStatus(7,5,"Reactor",statusR)
drawNoColor(7,6,"Fuel/t",fuel,"mB/t")
drawColor(7,7,"Temp",temp,-2000,"C")

drawStatus(7,9,"Turbine",statusT)
drawNoColor(7,10,"Speed",(maxTurbineSpeed+minTurbineSpeed)/2,"RPM")
drawNoColor(7,11,"Output",energyProduction,"RF/t")


--drawbox(8,20,colors.gray,7,5)
mon.setBackgroundColor(colors.black)
sleep(refreshtime)
end
