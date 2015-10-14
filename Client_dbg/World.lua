

--World handling module

local tilewidth  = 64
local tileheight = 32
local tile_decode = {}
grass = love.graphics.newImage('sprites/grass.png')

World = class('World')
WorldChunk = class('WorldChunk')

function WorldChunk:initialize(chunksize,worlddata,x,y)
  self.size = chunksize
  self.x = x
  self.y = y

  self.data = worlddata
end

rootchunk = WorldChunk:new(8,'00000000',0,0)


function World:initialize(size,ratio)
  self.chunks = {}
  self.size = size
  self.ratio = ratio
  self.pointer_x = 0
  self.pointer_y = 0
  self.chunkwidth = (self.size/self.ratio)*tilewidth
  self.chunkheight = (self.size/self.ratio)*tileheight
end


function World:NewChunk(dir, worlddata)
  self.pointer_x = self.pointer_x + dir[1]*self.chunkwidth/2
  self.pointer_y = self.pointer_y + dir[2]*self.chunkheight/2
  self.chunks[#self.chunks+1] = WorldChunk:new(#worlddata,worlddata,self.pointer_x,self.pointer_y)
end

--вот тут красивенько отрисовывает тайлы внутри собственно чанка
function WorldChunk:Draw()
  for i = 1, self.size do
    for j = 1, self.size do
        love.graphics.draw( grass , self.x+((j-1)*tileheight-(i-1)*tileheight), self.y+((j-1)*tileheight+(i-1)*tileheight)/2)
    end
  end
end


function World:Draw()
  for i = 1, #self.chunks do
    self.chunks[i]:Draw()
  end
end

MainWorld = World:new(32,4)
MainWorld.chunks[1] = rootchunk
MainWorld:NewChunk({-1,1},'00000000')
MainWorld:NewChunk({-1,-1},'00000000')
MainWorld:NewChunk({-1,-1},'00000000')
MainWorld:NewChunk({-1,-1},'00000000')
MainWorld:NewChunk({-1,-1},'00000000')
MainWorld:NewChunk({1,1},'00000000')
--MainWorld:NewChunk({1,-1},'00000000')
--MainWorld:NewChunk({1,1},'00000000')