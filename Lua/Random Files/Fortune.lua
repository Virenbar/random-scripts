--For coal, diamond, emerald, nether quartz, and lapis lazuli, level I gives a 33% chance to multiply drops by 2 (averaging 33% increase), level II gives a chance to multiply drops by 2 or 3 (25% chance each, averaging 75% increase), and level III gives a chance to multiply drops by 2, 3, or 4 (20% chance each, averaging 120% increase). 1 drop has a weight of 2, and each number of extra drops has a weight of 1. If commands are used to give an item an extremely high level of fortune, mining a block will make it drop an excessive amount of ore that can cause copious amounts of lag.

--For redstone, carrots, glowstone, sea lanterns, melons, nether wart, potatoes, beetroots (seeds only) and wheat (seeds only), each level increases the drop maximum by +1 (maximum 4 for glowstone, 5 for sea lanterns, and 9 for melon slices). For tall grass, each level increases the drop maximum by +2.
--chances = {'2'=20,'3'=20,'4'=20}
Fortune3 = {chances = {
    {multiply=1, chance = 0.4},
    {multiply=2, chance = 0.2},
    {multiply=3, chance = 0.2},
    {multiply=4, chance = 0.2}
    }, increase = 3}
math.randomseed(os.time())

function getFortuneResult(fortune)
    local rand = math.random()
    for k, v in ipairs(fortune.chances) do
        if rand <= v.chance then
            return v.multiply
        end
        rand = rand-v.chance
    end
end
function getOreResult(quantity,fortune)
    local result = 0
    for i=1,quantity do
        result = result + 1*getFortuneResult(fortune)
    end
    return result
end
InputOre=64*4

print(getOreResult(InputOre,Fortune3)/InputOre)
---[[
local min,avg,max = InputOre*4,0,0
local iterations = 10000
for i=1,iterations do
    local result = getOreResult(InputOre,Fortune3)
    avg = avg + result/iterations
    if result<min then min = result end
    if result>max then max = result end
end
print(min,avg,max)
--]]

--[[
local count = { }
local iterations = 100000
for i=1,iterations do
    local name = getOreResult(Fortune3)--getRandomItem()
    count[name] = (count[name] or 0) + 1
end
for name, count in pairs(count) do
    print(name, count/iterations)
end
--]]
