sqrt=math.sqrt

function LevelExp(Level)
    if Level<17 then return Level^2+6*Level end
    if Level<32 then return 2.5*Level^2 - 40.5*Level + 360 end
    if Level>=32 then return 4.5*Level^2 - 162.5*Level + 2220 end
end

function ExpLevel(Exp)
    --Thanks to Wolfram|Alpha for formulas
    if Exp<394 then return math.floor(sqrt(Exp+9)-3) end
    if Exp<1628 then return math.floor(1/10*(sqrt(40*Exp-7839)+81)) end
    if Exp>=1628 then return math.floor(1/18*(sqrt(72*Exp-54215)+325)) end
    
end

print(LevelExp(160))

print(ExpLevel(20000))
