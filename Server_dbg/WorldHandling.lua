require('table') 

local worldsize = 32 --размер мира 32х32
local ratio = 4      --скажем куски мира в 4 раза меньше самого мира

local World = class('World')
local Chunk = class('Chunk')

local chunks = {}


function Chunk:initialize(size)
  self.size = size
  self.data = ''
end


function World:initialize(size)
  
  self.size = size
  self.chunks = {}
  self.addition = {}
  self.r_addition = {}
  self.chunksize = self.size / ratio
  
  for i = 1, self.chunksize-1 do
    self.addition[i] = i
    self.r_addition[i] = (self.chunksize) - i
  end
  
  local k = 0
  local l = 1
  
  for i = 1, self.chunksize do
    
    k = k + i
    l = k
    
    chunks[k] = Chunk:new(self.size/ratio)
    
    for j = 1, #self.addition do
      chunks[l+self.addition[j]] = Chunk:new(self.size/ratio)
      l = l + self.addition[j]
    end
    
    if i < self.chunksize then
      table.remove(self.addition, 1)
      self.addition[#self.addition+1] = self.r_addition[1]
      table.remove(self.r_addition,1)
    end
  end
  
end

function Chunk:Fill(data)
  self.data = data
end

function World:sendChunk(id,ip)
  --print('chunk data sent' .. id .. '|' .. chunks[id].data,ip) 
  --server:send('006' .. id .. '|' .. chunks[id].data,ip)
end


MainWorld = World:new(worldsize) 

