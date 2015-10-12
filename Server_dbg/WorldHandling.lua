require('table') 

local worldsize = 64 --размер мира 32х32
local ratio = 8      --скажем куски мира в 4 раза меньше самого мира

local World = class('World')
local Chunk = class('Chunk')

function Chunk:initialize(size, data, num)
  self.size = size
  self.data = data
  self.num = num
end

function World:initialize(size)
  local n = 1
  self.size = size
  self.addition = {}
  self.r_addition = {}
  self.chunksize = self.size / ratio
  
  for i = 1, self.chunksize-1 do
    self.addition[i] = i
    self.r_addition[i] = (self.chunksize) - i
  end
  
  local k = 0
  local l = 1
  print(#self.addition)
  print(#self.r_addition)
  
  
  for i = 1, self.chunksize do
    
    k = k + i
    l = k
    
    Chunk:new(self.size/ratio,0,k)
    print('new chunk N  = ' .. k)
    
    for j = 1, #self.addition do
      Chunk:new(self.size/ratio,1,l+self.addition[j])
         print('new chunk N  = ' .. l+self.addition[j])
         l = l + self.addition[j]
    end
    
    
    if i < self.chunksize then
      table.remove(self.addition, 1)
      self.addition[#self.addition+1] = self.r_addition[1]
      table.remove(self.r_addition,1)
    end
    
  end
  
end

MainWorld = World:new(worldsize) 




--[[world = ''
worldsize = 8
function love.update()
  math.randomseed(os.time())
end
function genWorld()
  world = ''
  for i=1,worldsize do
    for j = 1,worldsize do
      if math.random(1,100)>50 then
        world = world .. '0'
      else
        world = world .. '1'
      end
    end
  end
return world
end-]]

