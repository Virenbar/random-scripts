AlphabetRU = {"А","Б","В","Г","Д","Е","Ж","З","И","Й","К","Л","М","Н","О","П","Р","С","Т","У","Ф","Х","Ц","Щ","Ы","Ь","Ч","Ш","Э","Ю","Я","Ё"}
AlphabetENG = {"A","B","W","G","D","E","V","Z","I","J","K","L","M","N","O","P","R","S","T","U","F","H","C","Q","Y","X"}
Morse = {".-","-...",".--","--.","-..",".","...-","--..","..",".---","-.-",".-..",
"--","-.","---",".--.",".-.","...","-","..-","..-.","....","-.-.","--.-","-.--", 
"-..-","---.", "----", "..-..","..--",".-.-","."}
Sumbols = {"1","2","3","4","5","6","7","8","9","0",",",".",";",":","?","№","\\",",","'","(","!","-",")"}
MorseS = {".----","..---","...--","....-",".....","-....","--...","---..",
"----.","-----",".-.-.-","......","-.-.-","---...","..--..","-..-.", 
".-..-.",".----.","-.--.-","--..--","-....-","-.--.-"}

PosArray = {}
Text = "АБВ"
LocalRU = true

--Time = 0
--pin = 17
--gpio.mode(pin,gpio.OUTPUT)

function FillPosArray()
  for i=1,#Text do
    --print(string.sub(Text,i,i+1))
    for Key,Value in ipairs(Sumbols) do
      if string.sub(Text,i,i) == Value then table.insert(PosArray,Key+100) end
    end  
    if LocalRU then
      for Key,Value in ipairs(AlphabetRU) do
        if string.sub(Text,i,i+1) == Value then table.insert(PosArray,Key) end --Костыль
      end
    else
      for Key,Value in ipairs(AlphabetENG) do
        if string.sub(Text,i,i) == Value then table.insert(PosArray,Key) end
      end
    end  
  end
end
--[[
function Wait(int)
  Time = 0
  tmr.start(0,int,function() Time = 1 end)
  repeat
    
  until Time == 1
  tmr.stop(0)
end
]]
function Dot()
--[[
  gpio.write(pin,gpio.LOW)
  Wait(500)
  gpio.write(pin,gpio.HIGH)
  ]]
  print(0)  
end

function  Dashe()
--[[
  gpio.write(pin,gpio.LOW)
  Wait(1000)
  gpio.write(pin,gpio.HIGH)
  ]]
  print(1)  
end

function Output(str)
  for i=1,#str do
    if string.sub(str,i,i) == "." then Dot() end
    if string.sub(str,i,i) == "-" then Dashe() end    
  end
end

function OutputPosTable()
  for _,V in ipairs(PosArray) do
    if V>100 then
      Output(MorseS[V-100])
    else
      Output(Morse[V])
    end
  end
end

FillPosArray()
OutputPosTable()

