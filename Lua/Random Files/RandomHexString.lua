Hex = "0123456789ABCDEF"

function RandomString(N)
  math.randomseed(os.time())
  for i=1,N do
    String = ""	
    for j=1,64 do
      R = math.random(1,16)
      --String = String..string.sub(Hex,R,R)
      io.write(string.sub(Hex,R,R))
  	end
  	print()
  end
end

function sleep(n)
  if n > 0 then os.execute("ping -n " .. tonumber(n+1) .. " localhost > NUL") end
end
--io.write()
RandomString(1000000)