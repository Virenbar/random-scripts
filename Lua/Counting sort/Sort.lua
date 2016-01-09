A = {7,30,20,14,13,20,30,7,6,1,2,1,0,-30}
B = {}
C = {}
Min = A[1]
Max = A[1]

function MinMax()
  for i=1,#A do
    if A[i]>Max then Max = A[i] end
    if A[i]<Min then Min = A[i] end
  end
end

function Sort()
  for i=Min,Max do
    B[i] = 0
  end
  for i=1,#A do
    B[A[i]] = B[A[i]]+1
  end
  A = {}
  for i=Min,Max do
    for j=1,B[i] do
      table.insert(A,i)
    end
  end
end

MinMax()
Sort()

for i=1,#A do
  print(A[i])
end