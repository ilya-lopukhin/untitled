
require("LUBE")
require("MiddleClass")
require("Stateful")
require("os")
require("math")
require("string")
NetTest = class('NetTest'):include(Stateful)
require("menu")
require("server")
require("WorldHandling")
genWorld()

function clearLoveCallbacks()
  love.draw = nil
  love.joystickpressed = nil
  love.joystickreleased = nil
  love.keypressed = nil
  love.keyreleased = nil
  love.load = nil
  love.mousepressed = nil
  love.mousereleased = nil
  love.update = nil
end

function NetTest:initialize()
  super.initialize(self)
  self:gotoState('Menu')
end

function love.load()
  netTest = NetTest:new()
end
