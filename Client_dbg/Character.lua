
local time = 0

Character = class('Character')

function Angle(x,y,tx,ty)
   return math.atan2(ty-y,tx-x)*180.0/math.pi
end

function Character:initialize(x,y,sprite)
  self.pos = vector.new(cam:worldCoords(x,y))
  self.sprite = sprite
  self.moveTrg = vector.new(self.pos.x,self.pos.y)
end

function Character:Draw()
  love.graphics.draw(self.sprite,self.pos.x-32,self.pos.y-60)
end

function Character:Move(speed)
  local an = self.pos:angleTo(self.moveTrg)
  local dist = self.pos:dist(self.moveTrg)

  if dist > 2 then
    print(dist)
    self.pos.x = self.pos.x + 0.05*(self.moveTrg.x - self.oldpos.x)
    self.pos.y = self.pos.y + 0.05*(self.moveTrg.y - self.oldpos.y)
  end
end

function Character:MoveTo(tx,ty)
  self.moveTrg.x = tx
  self.moveTrg.y = ty
  self.oldpos = vector.new(self.pos.x, self.pos.y)
end
