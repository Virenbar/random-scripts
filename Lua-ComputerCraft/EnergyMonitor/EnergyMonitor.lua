local R = 1
local w1 = 6
local w2 = 10
--elite_energy_cube
local output = 'left'
local cube = peripheral.find("inductionPort")
local monitors = {peripheral.find("monitor")}
local oldEnergy = cube.getEnergy()
local maxEnergy = cube.getMaxEnergy()
local mon = {}
--
function reset()
  mon.clear()
  mon.setCursorPos(1,1)
  mon.setTextColor(colors.white)
end
function newline()
  x, y = mon.getCursorPos()
  mon.setCursorPos(1,y+1)
  mon.setTextColor(colors.white)
end
function rpad1(s)
  s = tostring(s)
  local pad=w1-#s
  return string.rep(" ",pad) .. s
end
function rpad2(s)
  s = tostring(s)
  local pad=w2-#s
  return string.rep(" ",pad) .. s
end
function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end
function formatEnergy(n)
  --local placeValue = ("%%.%df"):format(places or 0)
  if not n then
    return 0
  elseif n >= 1e12 then
    return string.format("%.2f TFE", n / 1e12)
  elseif n >= 1e9 then
    return string.format("%.2f GFE", n / 1e9)
  elseif n >= 1e6 then
    return string.format("%.2f MFE", n / 1e6)
  elseif n >= 1e3 then
    return string.format("%.2f kFE", n / 1e3)
  else
    return string.format("%.2f FE", n)
  end
end

--Modifyed print
function printnocolor(name,value,unit)
  mon.write(rpad1(name)..": "..rpad2(tostring(round(value,3))).." "..unit)
  newline()
end
function printcolor(name,value,maxvalue,unit)
  mon.write(rpad1(name)..": ")
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
  mon.write(rpad2(tostring(round(value,3))).." "..unit)
  newline()
end

function printEnergy(energy,max)
  mon.write(rpad1('Energy')..": ")
  local percent = math.floor(energy/math.abs(max)*100)
  if percent > 66 then mon.setTextColor(colors.green)
  elseif percent < 34 then mon.setTextColor(colors.red)
  else mon.setTextColor(colors.yellow)
  end
  local e = formatEnergy(energy)
  local m = formatEnergy(max)
  mon.write(rpad2(e).."/"..m)
  newline()
end
function printYield(energy)
  mon.write(rpad1('Yield')..": ")
  if energy > 0 then mon.setTextColor(colors.green)
  else mon.setTextColor(colors.red) end
  --local e = formatEnergy(energy)
  mon.write(rpad2(round(energy,3)).." FE/t")
  newline()
end
function setRedstone(percent)
  if percent < 50 then 
    redstone.setOutput(output, true)
  elseif percent > 95 then
    redstone.setOutput(output, false)
  end
end

print(maxEnergy)
while true do
  local energy = cube.getEnergy()
  local percent = energy/maxEnergy*100
  local change = (energy-oldEnergy)/(R*20)
  oldEnergy = energy
  for _,cmon in pairs(monitors) do
    mon = cmon  
    reset()
    printEnergy(energy,maxEnergy)
    printYield(change)
  end
  --print(percent)
  setRedstone(percent)
  sleep(R)
end