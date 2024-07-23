module = {}

function module.create(monitors)
  -- https://www.computercraft.info/forums2/index.php?/topic/21363-multiple-monitors-one-computer/
  local mon = {}
  for funcName, _ in pairs(monitors[1]) do
    mon[funcName] = function(...)
      local arg = { ... }
      for i = 1, #monitors - 1 do
        monitors[i][funcName](unpack(arg))
      end
      return monitors[#monitors][funcName](unpack(arg))
    end
  end

  function mon.reset()
    mon.clear()
    mon.setCursorPos(1, 1)
    mon.setTextColor(colors.white)
  end

  function mon.newline()
    local _, y = mon.getCursorPos()
    mon.setCursorPos(1, y + 1)
    mon.setTextColor(colors.white)
  end

  return mon
end

---comment
---@param value string
---@param color string|nil
---@return table
function module.createText(value, color)
  local text = {
    value = value,
    color = color or "white"
  }
  return text
end

---comment
---@param value string
---@param color string
---@return table
function module.createLabel(value, color)
  local text = {
    value = value,
    color = color or "white"
  }
  return text
end

return module
