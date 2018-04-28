stack = {}
function Push(a)
  stack[#stack+1] = a
end
function Pop()
  if #stack == 0 then
    return 'Z'
  end
  return table.remove(stack)
end
function Seek()
  if #stack == 0 then
    return 'Z'
  end
	return stack[#stack]
end
----------------------------------------
Simbols = {'(',')','[',']','\n'}
Flags = {'Z','A','B'}
Statuses = {'N'}
ret = null
--[[
N = {}
for i=1,#Simbols do
  N[Simbols[i] ] = {}
  for j=1,#Flags do
  	N[Simbols[i] ][Flags[j] ] = ''
  end    
end
]]--

function Error(need,get)
	print('Ожидалось '..need..', получено '..get..'!')
	ret = 1 
end
function Check(Simbol)
  --Simbol = code:sub(i,i)
  Flag = Seek()
  if Status == 'N' then
    if Simbol == '(' and Flag == 'Z' then Push('A') end
    if Simbol == '(' and Flag == 'A' then Push('A') end
    if Simbol == '(' and Flag == 'B' then Push('A') end
    if Simbol == ')' and Flag == 'Z' then Error('конец строки',')') end
    if Simbol == ')' and Flag == 'A' then Pop() end
    if Simbol == ')' and Flag == 'B' then Error(']',')') end
    if Simbol == '[' and Flag == 'Z' then Push('B') end
    if Simbol == '[' and Flag == 'A' then Push('B') end
    if Simbol == '[' and Flag == 'B' then Push('B') end
    if Simbol == ']' and Flag == 'Z' then  Error('конец строки',']') end
    if Simbol == ']' and Flag == 'A' then Error(')',']') end
    if Simbol == ']' and Flag == 'B' then Pop() end
    if Simbol == '\n' and Flag == 'Z' then ret = 2 end
    if Simbol == '\n' and Flag == 'A' then Error(')','конец строки') end
    if Simbol == '\n' and Flag == 'B' then Error(']','конец строки') end
  end
end

Status = 'N'
code = '([()]())\n([()]())\n' 
print(code)
for i=1,#code do
  Check(code:sub(i,i))
  if ret == 2 then print('Строка верна') end
  if ret == 1 then break end
  ret = 0
end 