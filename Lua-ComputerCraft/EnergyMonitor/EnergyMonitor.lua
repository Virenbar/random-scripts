local M = require "monitor"
--
local delay = 1
local w1 = 6
local w2 = 10
--
local toFE = mekanismEnergyHelper.joulesToFE
local output = 'left'
local cube = peripheral.find("inductionPort")
local monitors = { peripheral.find("monitor") }
local T = M.create(monitors)
--
local state = {
  percent = 0,
  energy = 0,
  change = 0,
  maxEnergy = 100
}
--

local function rpad(s, w)
  s = tostring(s)
  local pad = w - #s
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

local function updateInfo()
  state.maxEnergy = toFE(cube.getMaxEnergy())
  state.energy = toFE(cube.getEnergy())
  state.change = toFE(cube.getLastInput()) - toFE(cube.getLastOutput())
  state.percent = cube.getEnergyFilledPercentage() * 100
end

local function updateOutput()
  if state.percent < 50 then
    redstone.setOutput(output, true)
  elseif state.percent > 95 then
    redstone.setOutput(output, false)
  end
end

local function printInfo()
  local t = term.redirect(T)
  local W = term.getSize()
  T.reset()
  --
  local color = colors.yellow
  if state.percent > 66 then
    color = colors.green
  elseif state.percent < 34 then
    color = colors.red
  end
  local e = formatEnergy(state.energy)
  local m = formatEnergy(state.maxEnergy)
  T.write(rpad('Energy', w1) .. ": ")
  T.setTextColor(color)
  T.write(rpad(e, w2) .. "/" .. m)
  T.newline()
  --
  local colorY = ternary(state.change > 0, colors.green, colors.red)
  T.write(rpad('Yield', w1) .. ": ")
  T.setTextColor(colorY)
  T.write(rpad(round(state.change, 3), w2) .. " FE/t")
  T.newline()
  --

  term.setBackgroundColor(colors.black)
  paintutils.drawBox(1, 3, W, 5, colors.gray)
  paintutils.drawBox(2, 4, (W - 1) / 100 * state.percent, 4, color)
  --
  term.redirect(t)
end

sleep(5)
state.maxEnergy = toFE(cube.getMaxEnergy())
print(state.maxEnergy)
while true do
  --print(toFE(cube.getLastInput()) - toFE(cube.getLastOutput()))
  updateInfo()
  updateOutput()
  printInfo()
  --print(percent)
  sleep(delay)
end
