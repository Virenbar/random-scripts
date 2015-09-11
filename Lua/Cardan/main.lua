----------------------------------------
--01,02,03,04 + a,b,c,a = a[1,4,16,13]--
--05,06,07,08 + c,d,d,b = b[2,8,15,9] --
--09,10,11,12 + b,d,d,c = c[5,3,12,14]--
--13,14,15,16 + a,c,b,a = d[6,7,11,10]--
----------------------------------------
Q = {"Ò","Ç","Ô","Î",
     "À","Ð","À","È",
     "Ö","Í","À","È",
     "Ù","È","Ì","È"}
key = ""
A = ""

a = {1,4,16,13}
b = {2,8,15,9}
c = {5,3,12,14}
d = {6,7,11,10}

function slide(array,pos)
    if pos == nil then pos = 1 end
    for j = 1,pos do    
        local first = array[1]
        for i = 1,#array-1 do
            array[i] = array[i+1]    
        end
        array[#array] = first
    end
end

function dec3(decimal)
    local i4 = math.floor((decimal % 256)/64) 
    local i3 = math.floor((decimal % 64)/16)
    local i2 = math.floor((decimal % 16)/4)
    local i1 = math.floor(decimal % 4) 
    return i4,i3,i2,i1
end

function arraystr(array)
    local str = "|"
    for i=1,#array do
        str = str..array[i].."|"   
    end
    return str  
end

function main()
    --for i=0,255 do
    for i4=0,3 do
        for i3=0,3 do
            for i2=0,3 do
                for i1=0,3 do
                    key = arraystr(a).." "..arraystr(b).." "..arraystr(c).." "..arraystr(d)
                    A = ""
                    for i0=1,4 do
                        local sorted = {a[i0],b[i0],c[i0],d[i0]}
                        table.sort(sorted)
                        A = A..Q[sorted[1]]..Q[sorted[2]]..Q[sorted[3]]..Q[sorted[4]]
                    end
                    print((i1+i2*4+i3*16+i4*64).." "..A)
                    slide(d)
                end
                slide(c)
            end
            slide(b)
        end
        slide(a)
    end            
    --slide(a)
    --print(a[4])
    --print(dec3(256))
end

main()

