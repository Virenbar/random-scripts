function F(x)
    if x==0 then return 0 end
    return F(x-1)+(-1)^(x-1)*x
end

local function main()
    for i =0,5 do
        print(F(i))
    end
end
main()
