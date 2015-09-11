str = "qwe*ewq"
stack = {}


function pop(array)
    last = array[#array]
    table.remove(array)
    return last
end    
function push(array,item)
    array[#array+1] = item
end

function main()
    io.write("Input string:\n")
    str = io.read()
    if (#str%2 == 0) or (str == nil) then
        print("Incorrect string\n")
        return 0
    end
    star = math.floor(#str/2)+1
    for i=1,star-1 do
         push(stack,str:sub(i, i))
    end
    for i=star+1,#str do       
        if not (str:sub(i, i) == pop(stack)) then
            print("String is not mirrored\n")
            return 0
        end
    end
    print("String is mirrored\n")
    return 1
end

main()