local U = require "monitor"
--
local delay = 1
local w1 = 6
local w2 = 10
--
local toFE = mekanismEnergyHelper.joulesToFE
local output = 'left'
local cube = peripheral.find("inductionPort")
local monitors = { peripheral.find("monitor") }
--
local T = U.create(monitors)
local percent = 0
local energy = 0
local change = 0
local maxEnergy = toFE(cube.getMaxEnergy())
--

local function rpad1(s)
  s = tostring(s)
  local pad = w1 - #s
  return string.rep(" ", pad) .. s
end

local function rpad2(s)
  s = tostring(s)
  local pad = w2 - #s
  return string.rep(" ", pad) .. s
end

local function round(num, idp)
  local mult = 10 ^ (idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

local function ternary(condition, T, F)
  if condition then return T else return F end
end

local function formatEnergy(n)
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

-- Modifyed print
local function printnocolor(name, value, unit)
  T.write(rpad1(name) .. ": " .. rpad2(tostring(round(value, 3))) .. " " .. unit)
  newline()
end

local function printcolor(name, value, maxvalue, unit)
  T.write(rpad1(name) .. ": ")
  local percent = math.floor(value / math.abs(maxvalue) * 100)
  if maxvalue > 0 then
    if percent > 66 then
      T.setTextColor(colors.green)
    elseif percent < 34 then
      T.setTextColor(colors.red)
    else
      T.setTextColor(colors.yellow)
    end
  else
    if percent > 66 then
      T.setTextColor(colors.red)
    elseif percent < 34 then
      T.setTextColor(colors.green)
    else
      T.setTextColor(colors.yellow)
    end
  end
  T.write(rpad2(tostring(round(value, 3))) .. " " .. unit)
  newline()
end

local function updateInfo()
  energy = toFE(cube.getEnergy())
  change = toFE(cube.getLastInput() - cube.getLastOutput())
  percent = cube.getEnergyFilledPercentage()
end

local function updateOutput()
  if percent < 50 then
    redstone.setOutput(output, true)
  elseif percent > 95 then
    redstone.setOutput(output, false)
  end
end

local function printInfo()
  T.reset()
  local color = colors.yellow
  if percent > 66 then
    color = colors.green
  elseif percent < 34 then
    color = colors.red
  end
  local e = formatEnergy(energy)
  local m = formatEnergy(maxEnergy)
  T.write(rpad1('Energy') .. ": ")
  T.setTextColor(color)
  T.write(rpad2(e) .. "/" .. m)
  T.newline()

  color = ternary(change > 0, colors.green, colors.red)
  T.write(rpad1('Yield') .. ": ")
  T.setTextColor(color)
  T.write(rpad2(round(change, 3)) .. " FE/t")
  T.newline()
end

sleep(1)
print(maxEnergy)
while true do
  updateInfo()
  updateOutput()
  printInfo()
  --print(percent)
  sleep(delay)
end
