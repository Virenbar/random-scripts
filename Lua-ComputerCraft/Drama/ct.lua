module = {}

function module.print(mon, sText)
  local w, h = mon.getSize()
  local x, y = mon.getCursorPos()
  local str = ""
  local function newLine()
    x, y = mon.getCursorPos()
    mon.setCursorPos((math.floor(w / 2) - (math.floor(#str / 2))) + 1, y)
    mon.write(str)
    str = ""
    mon.setCursorPos(1, y + 1)
    x, y = mon.getCursorPos()
  end
  if #sText < w then
    str = sText
    newLine()
  else
    -- Print the line with proper word wrapping
    while string.len(sText) > 0 do
      local whitespace = string.match(sText, "%s*") --"^[ t]+"
      if whitespace then
        -- Print whitespace
        str = str .. whitespace
        --mon.write(whitespace)
        x, y = mon.getCursorPos()
        sText = string.sub(sText, string.len(whitespace) + 1)
      end

      local text = string.match(sText, "%S*") --"^[^ tn]+"
      if text then
        sText = string.sub(sText, string.len(text) + 1)
        if string.len(text) > w then
          -- Print a multiline word
          while string.len(text) > 0 do
            if #str > w then
              newLine()
            end
            --mon.write(text)
            str = str .. text
            text = string.sub(text, (w - #str) + 2)
            x, y = mon.getCursorPos()
          end
        else
          -- Print a word normally
          if #str + string.len(text) > w then
            newLine()
          end
          --mon.write(text)
          str = str .. text
          x, y = mon.getCursorPos()
        end
      end
      --print(#str)
    end
    newLine()
  end
end

return module
