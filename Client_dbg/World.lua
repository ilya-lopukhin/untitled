--World handling module

local tilewidth  = 64
local tileheight = 32
local tile_decode = {}
grass = love.graphics.newImage('sprites/grass.png')

World = class('World')
WorldChunk = class('WorldChunk')

function WorldChunk:initialize(chunksize,x,y)
  self.size = chunksize
  self.x = x 
  self.y = y
  self.tiles = {}
end


function World:initialize(size, ratio)
  self.firstchunk = true
  self.x = 0
  self.y = 0
  self.size = size
  self.ratio = ratio
  self.chunks = {}
  self.chunksize = self.size/self.ratio
  self.numchunks = (self.size*self.size)/(self.chunksize*self.chunksize)
  self.squrtchunks = math.sqrt(self.numchunks)
  self.chunkheight = self.chunksize*tileheight
  self.chunkwidth = self.chunksize*tilewidth
--короч, тут все просто, по гайдику, проставляются координаты чанками как будто это тайлы размером self.chunksize*self.chunksize тайлов
  
  for i = 1, self.squrtchunks do
    for j = 1, self.squrtchunks do
      --print((j-1)*self.chunkheight+(i-1)*self.chunkheight .. ':' .. ((j-1)*self.chunkheight-(i-1)*self.chunkheight)/2)
      self.chunks[#self.chunks+1] = WorldChunk:new(self.chunksize, (j-1)*self.chunkheight+(i-1)*self.chunkheight , ((j-1)*self.chunkheight-(i-1)*self.chunkheight)/2)
    end
  end
end

--типа какому тайлу какая картинка принадлежит на отрисовку. эту хуиту нужно поменять, сделать отдельный класс Tile скорее всего.
function World:NewTile(num, tile)
  tile_decode[num] = tile
end

--типа заполняет чанк говном пришедшим с сервера вроде 10010101001110 где 1 - трава а 0 - говно
function World:FillChunk(datastring,chunknum)
  self.chunks[chunknum]:Fill(datastring)
  print('new chunk N ' .. chunknum .. ' = ' .. datastring)
end

--типа по строке из предыдущей функции заполняет одномерный МАССИВ С ТАЙЛАМИ НАХУЙ ЕПТА. это скоро поменяю нахуй
function WorldChunk:Fill(datastring)
  for i = 1, self.size do
      self.tiles[#self.tiles+1] = string.sub(datastring,i,i)
  end
end

--вот тут красивенько отрисовывает тайлы внутри собственно чанка
function WorldChunk:Draw()
  for i = 1, self.size do
    for j = 1, self.size do
        love.graphics.draw( grass , self.x+((j-1)*tileheight-(i-1)*tileheight), self.y+((j-1)*tileheight+(i-1)*tileheight)/2)
    end
  end
end

--тут по дибильной нумерации рисуются все чанки подряд в данном мире(блоке чанков)
function World:Draw()
  local k = 0
  for i = 1, self.squrtchunks do
    for j = 1, self.squrtchunks do
      k = k+1
      self.chunks[k]:Draw()
    end
  end
end
--[[i = 1 j = 1 ; x = 1
i = 1 j = 2 ; x = 2
i = 1 j = 3 ; x = 4 
i = 2 j = 1 ; x = 3
i = 2 j = 2 ; x = 5
i = 2 j = 3 ; x = 7
i = 3 j = 1 ; x = 6
i = 3 j = 2 ; x = 8
i = 3 j = 3 ; x = 9
1, 
1+1, 
1+1+2, 
1+1+2-1, 
1+1+2-1+2, 
1+1+2-1+2+2, 
1+1+2-1+2+2-1, 
1+1+2-1+2+2-1+2, 
1+1+2-1+2+2-1+2+1]]--