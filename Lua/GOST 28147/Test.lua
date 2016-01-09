p = 47
q = 71
n = p * q
e = 0
y = 0

print('n = '..n)
for i=n,0,-1 do
  if (n%i == 0) and (((p-1)*(q-1))%i == 0) then e=i break end
end
print('e = '..e)
e = 79
print('e = '..e)

repeat
  y = y-1
  d =(1-(p-1)*(q-1)*y)/e
until d%1 == 0
print('y = '..y)
print('d = '..d)
m = 688
c = ((m^e) % n)

print(m^e)
print(c) 