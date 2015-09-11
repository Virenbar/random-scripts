function turbineInductorDisplay(posx,posy,status)
  local coilColor = colors.red
  if ani == 0 then ani = 1
  else ani = 0
  end
  if status then
	  coilColor = colors.blue
	end
  mon.setCursorPos(posx,posy)
  drawline(7,colors.gray)
  --
  for i = 1,11 do
    mon.setCursorPos(posx,posy+i)
    drawline(1,colors.gray)
	  if (ani == 0 and i % 2 == 0) then
      drawline(5,colors.gray)
    elseif (ani == 1 and i % 2 == 0) then
      drawline(1,colors.lightGray)
      drawline(3,colors.gray)
      drawline(1,colors.lightGray)
    else
      drawline(2,colors.lightGray)
      drawline(1,colors.gray)
      drawline(2,colors.lightGray)
	  end
    drawline(1,colors.gray)
  end
  --]]
  --[[
  for i = 1,11 do
    mon.setCursorPos(posx,posy+i)
	  drawline(1,colors.gray)
    drawline(1,colors.lightGray)
	  if (ani == 0 and i % 2 == 0) or (ani == 1 and i % 2 ~= 0) then
      drawline(3,colors.gray)
    else
      drawline(1,colors.lightGray)
      drawline(1,colors.gray)
      drawline(1,colors.lightGray)
	  end
    drawline(1,colors.lightGray)
    drawline(1,colors.gray)
  end
  --]]
  for i = 11,15 do
    mon.setCursorPos(posx,posy+i)
	  drawline(1,colors.gray)
    drawline(1,colors.lightGray)
    drawline(1,coilColor)
    drawline(1,colors.gray)
    drawline(1,coilColor)
    drawline(1,colors.lightGray)
    drawline(1,colors.gray)
  end
  mon.setCursorPos(posx,posy+16)
  drawline(7,colors.gray)
  mon.setBackgroundColor(colors.black)
end


function turbineTop(posx,posy)
  if ani == 0 then ani = 1
  else ani = 0
  end
  drawbox(posx,posy,colors.gray,7,7)
  drawbox(posx+1,posy+1,colors.lightGray,5,5)
  if ani == 0 then
    mon.setCursorPos(posx+1,posy+1)
    draw2colorline({2,1,2},colors.lightGray,colors.gray)
    mon.setCursorPos(posx+1,posy+2)
    draw2colorline({2,1,2},colors.lightGray,colors.gray)
    mon.setCursorPos(posx+1,posy+3)
    drawline(5,colors.gray)
    mon.setCursorPos(posx+1,posy+4)
    draw2colorline({2,1,2},colors.lightGray,colors.gray)
    mon.setCursorPos(posx+1,posy+5)
    draw2colorline({2,1,2},colors.lightGray,colors.gray)
  else
    mon.setCursorPos(posx+1,posy+1)
    draw2colorline({1,3,1},colors.gray,colors.lightGray)
    mon.setCursorPos(posx+1,posy+2)
    draw2colorline({1,1,1,1,1},colors.lightGray,colors.gray)
    mon.setCursorPos(posx+1,posy+3)
    draw2colorline({2,1,2},colors.lightGray,colors.gray)
    mon.setCursorPos(posx+1,posy+4)
    draw2colorline({1,1,1,1,1},colors.lightGray,colors.gray)  
    mon.setCursorPos(posx+1,posy+5)
    draw2colorline({1,3,1},colors.gray,colors.lightGray)
  end
end