local R = 1
local w1 = 6
local w2 = 10
--
local toFE = mekanismEnergyHelper.joulesToFE
local output = 'left'
local cube = peripheral.find("inductionPort")
local monitors = { peripheral.find("monitor") }
--
local mon = {}
local percent = 0
local energy = 0
local change = 0
local maxEnergy = toFE(cube.getMaxEnergy())
--
function reset()
  mon.clear()
  mon.setCursorPos(1, 1)
  mon.setTextColor(colors.white)
end

function newline()
  local x, y = mon.getCursorPos()
  mon.setCursorPos(1, y + 1)
  mon.setTextColor(colors.white)
end

function rpad1(s)
  s = tostring(s)
  local pad = w1 - #s
  return string.rep(" ", pad) .. s
end

function rpad2(s)
  s = tostring(s)
  local pad = w2 - #s
  return string.rep(" ", pad) .. s
end

function round(num, idp)
  local mult = 10 ^ (idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function ternary(condition, T, F)
  if condition then return T else return F end
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
function printnocolor(name, value, unit)
  mon.write(rpad1(name) .. ": " .. rpad2(tostring(round(value, 3))) .. " " .. unit)
  newline()
end

function printcolor(name, value, maxvalue, unit)
  mon.write(rpad1(name) .. ": ")
  local percent = math.floor(value / math.abs(maxvalue) * 100)
  if maxvalue > 0 then
    if percent > 66 then
      mon.setTextColor(colors.green)
    elseif percent < 34 then
      mon.setTextColor(colors.red)
    else
      mon.setTextColor(colors.yellow)
    end
  else
    if percent > 66 then
      mon.setTextColor(colors.red)
    elseif percent < 34 then
      mon.setTextColor(colors.green)
    else
      mon.setTextColor(colors.yellow)
    end
  end
  mon.write(rpad2(tostring(round(value, 3))) .. " " .. unit)
  newline()
end

local function updateInfo()
  energy = toFE(cube.getEnergy())
  change = toFE(cube.getLastInput() - cube.getLastOutput())
  percent = cube.getEnergyFilledPercentage()
end

local function printInfo()
  reset()
  local color = colors.yellow
  if percent > 66 then
    color = colors.green
  elseif percent < 34 then
    color = colors.red
  end
  local e = formatEnergy(energy)
  local m = formatEnergy(maxEnergy)
  mon.write(rpad1('Energy') .. ": ")
  mon.setTextColor(color)
  mon.write(rpad2(e) .. "/" .. m)
  newline()

  color = ternary(change > 0, colors.green, colors.red)
  mon.write(rpad1('Yield') .. ": ")
  mon.setTextColor(color)
  mon.write(rpad2(round(change, 3)) .. " FE/t")
  newline()
end

sleep(1)
print(maxEnergy)
while true do
  updateInfo()
  for _, cmon in pairs(monitors) do
    mon = cmon
    printInfo()
  end
  --print(percent)
  if percent < 50 then
    redstone.setOutput(output, true)
  elseif percent > 95 then
    redstone.setOutput(output, false)
  end
  sleep(R)
end
