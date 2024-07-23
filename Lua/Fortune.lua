--For coal, diamond, emerald, nether quartz, and lapis lazuli, level I gives a 33% chance to multiply drops by 2 (averaging 33% increase), level II gives a chance to multiply drops by 2 or 3 (25% chance each, averaging 75% increase), and level III gives a chance to multiply drops by 2, 3, or 4 (20% chance each, averaging 120% increase). 1 drop has a weight of 2, and each number of extra drops has a weight of 1. If commands are used to give an item an extremely high level of fortune, mining a block will make it drop an excessive amount of ore that can cause copious amounts of lag.

--For redstone, carrots, glowstone, sea lanterns, melons, nether wart, potatoes, beetroots (seeds only) and wheat (seeds only), each level increases the drop maximum by +1 (maximum 4 for glowstone, 5 for sea lanterns, and 9 for melon slices). For tall grass, each level increases the drop maximum by +2.
--chances = {'2'=20,'3'=20,'4'=20}


math.randomseed(os.time())
arr = {0,0,0,0,0}
for i=1,1000 do
  rand = math.random(1,5)
  arr[rand]=arr[rand]+1
end
for i=1,#arr do
  print(arr[i])
end

items = {
    Cat     = { probability = 100/1000 }, -- i.e. 1/10
    Dog     = { probability = 200/1000 }, -- i.e. 2/10
    Ant     = { probability = 699/1000 },
    Unicorn = { probability =   1/1000 },
}

function getRandomItem()
    local p = math.random()
    local cumulativeProbability = 0
    for name, item in pairs(items) do
        cumulativeProbability = cumulativeProbability + item.probability
        if p <= cumulativeProbability then
            return name, item
        end
    end
end

local count = { }

local iterations = 1000000
for i=1,iterations do
    local name = getRandomItem()
    count[name] = (count[name] or 0) + 1
end

for name, count in pairs(count) do
    print(name, count/iterations)
end