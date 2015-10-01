Alphabet = {"А","Б","В","Г","Д","Е","Ё","Ж","З","И","Й","К","Л","М","Н","О","П","Р","С","Т","У","Ф","Х","Ц","Ч","Ш","Щ","Ъ","Ы","Ь","Э","Ю","Я"};
Letters = {}

--T = io.open("book1.txt")

function Count(ss)
  local N = 0
  for line in io.lines("book1.txt") do--T:lines() do
    --print(line)
    _,count = string.gsub(line,ss,ss)
    N = N + count
    --_,count = string.gsub("ААА",letters,letters)
  end
  return N
end

function main()
  for _,letter in ipairs(Alphabet) do
    Letters[letter] = Count(letter)
    --A = {}
    --A["А"] = 10
    print(letter.." = "..Letters[letter])   
  end
end
main()