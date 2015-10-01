
local Tree = {}
Tree.__index = Tree

function Tree:new(width, value, parent, index)
  local tree = setmetatable({}, Tree) --Создание пустого массива с заданными метаданными
  tree.width = width     -- Максимальное кол-во потомков
  tree.value = value     -- Значение узла
  tree.parent = parent   -- Родитель
  tree.index = index     -- Индекс узла в родителе
  return tree
end
-- Установить значение узла
function Tree:set(value)
  self.value = value
end
-- Получить значение узла
function Tree:get()
  return self.value
end
-- Установка ширины дерева
function Tree:setWidth(width)
  for i = 1,self.width do
    if self[i] then self[i]:setWidth(width) end
  end
  self.width = width
end
-- Создание и возрат потомка
function Tree:newChild(i, value, i2, ...)
  i = i or #self+1
  if self[i] then self[i]:remove() end
  self[i] = Tree:new(self.width, value, self, i)
  return self[i], i2 and self:newChild(i2, ...) or nil
end
-- Удаление узла
function Tree:remove()
  if self.parent then
    self.parent[self.index] = nil
    self.parent = nil
    self.index = nil
  end
  return self
end
-- Вызов дерева, как функции создаст и вернёт потомка.
function Tree:__call(i,...)
  if not self[i] then self:newChild(i,...) end
  return self[i]
end
-- Поиск в глубину
function Tree:iterate()
  local nodes = {}                -- Массив узлов
  local depths = {}               -- Массив глубин узлов
  local k,i = 0,0                 -- Начальный и конечный индекс
  local depth = -1                -- Текушая глубина
    
  --Родитель, левая ветвь, правая ветвь
  local function recursion(node)
  if node == nil then return end
    depth = depth+1
    i = i+1
    nodes[i] = node
    depths[i] = depth
    print(depth.." : "..node:get())
    for j=1,node.width or #node do
      recursion(node[j])
    end
    depth = depth-1
  end

  recursion(self)
  k = 0
  --[[
  return function()
    if k >= i then return nil end
    k = k+1
    return d[k], n[k]
  end
  --]]
end

tree = Tree:new(2)
tree:set("1")
--tree(1):set("2")
tree(1,"2")
tree(2,"5")
tree(1)(1,"3")
tree(1)(2,"4")
tree(2)(1,"6")
tree(2)(2,"7")
tree:iterate()

--[[
T = tree:iterate()
while true do
  d1,n1 = T()
  if n1 == nil then break end
  print(n1:get())
end
--]]

--http://ilovelua.narod.ru/about_lua.html
