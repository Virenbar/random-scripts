LuckyTable = {}

function NumSum(Num)
	local I = 1
	local Sum = 0
	while Num>0 do
		Sum = Sum + (Num%(10^I))/(10^(I-1))
		Num = Num - (Num%(10^I))
		I = I+1
	end
	return Sum
end

function LuckyN(Start,N)
  for Left=Start,999 do
  	for Right=1,999 do
      if NumSum(Left)==NumSum(Right) then
      	LuckyTable[#LuckyTable+1] = Left*1000+Right
      	print(Left*1000+Right)
      	if #LuckyTable == N then return end
      end
    end
  end
end

--print(NumSum(999))
LuckyN(300,10)