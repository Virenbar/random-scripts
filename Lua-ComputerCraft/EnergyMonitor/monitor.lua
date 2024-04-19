module = {}

function module.create(monitors)
  local mon = {}
  for funcName, _ in pairs(monitors[1]) do
    mon[funcName] = function(...)
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

return module
