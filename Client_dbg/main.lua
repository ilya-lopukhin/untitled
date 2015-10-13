--0295

require("os")
require("math")
require("string")
utf8 = require("utf8")


require("LUBE")
require("MiddleClass")
require("Stateful")
Lamp = class('Lamp'):include(Stateful)
require("Menu")
require("Client")
require("World")
require("Game")
require("GUI")

Camera = require("camera")

Font = love.graphics.getFont()
  
loginfree = false

love.keyboard.setTextInput(false)

chat = {}

client_names = {}

id = 0
client_names[id] = 'noname'

world = {}

login = ''

pass = ''

input = ''

mainfont = love.graphics.newFont('sprites/Main.ttf',14)
love.graphics.setFont(mainfont);


function love.textinput(text)
  input = input .. text
end

function round(x)
  if x%math.floor(x) > 0.5 then
    return math.ceil(x)
  else
    return math.floor(x)
  end
end

function toIso(x,y)
  return x-y,(x+y)/2
end

function toCartesian(isox,isoy)
  return (2*isoy+isox)/2,(2*isoy-isox)/2
end
  
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

function Lamp:initialize()
  super.initialize(self)
  self:gotoState('Menu')
end

function love.load()
  Lamp = Lamp:new()
end
