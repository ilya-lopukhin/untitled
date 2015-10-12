--0295
require("LUBE")
require("MiddleClass")
require("Stateful")
require("os")
Camera = require("camera")
require("math")
require("string")
require("GUI")
utf8 = require("utf8")
NetTest = class('NetTest'):include(Stateful)
require("menu")
require("client")
require("World")

  Font = love.graphics.getFont()
  loginfree = false
  love.keyboard.setTextInput(false)
  message = ""
  chat = {}
  clients = {}
  client_name = {}
  input_line = 0
  id = 0
  client_name[id] = 'noname'
  step = 0
  world = {}
  login = ''
  pass = ''
  input = ''
  ratio = 4
  loginphrase = 'Enter login '
  passphrase = 'Enter pass '
  messages = {}
  mainfont = love.graphics.newFont('sprites/Main.ttf',14)
  love.graphics.setFont(mainfont);

  client = lube.client()
  client:setHandshake("Hi!")
  client:setCallback(onReceive)
  success = client:connect("84.23.33.186", 3557)
  connected = client.connected
  if connected  and success then
    print("connected!")
  end
  

  

    function love.textinput(text)
       input = input .. text
    end
  
    function onReceive(data)

     pheader = string.sub(data,1,3)
     data = string.sub(data,4)
     print('RECIEVED ' .. data .. ' WITH HEADER ' .. pheader .. ' FROM SERVER')
     
      if(pheader == '000') then
        print('auth failed or user already exists')
        backtoMenu()
      end
      if(pheader == '001') then
        print('login is free')
        loginfree = true
      end
      if(pheader == '002') then
        print('User ' .. login .. ' registered')
      end
      if(pheader == '003') then
        print('auth passed')
        netTest:gotoState('Client')
      end
      if(pheader == '004') then
        sender = string.sub(data,1,5)
        message = string.sub(data, 6)
       -- print('new message ' .. message .. ' from ' .. client_name[sender]) 
      if sender == '10000' then
        chat[#chat+1] = "System message : " .. message
      else
        chat[#chat+1] = client_name[sender] .. " : " .. message
      end
      end
      if(pheader  == '005') then
        newid = string.sub(data,1,5)
        newname = string.sub(data,6)
        print('new client with id ' .. newid .. ' and name ' .. newname)
        client_name[newid] = newname
        clients[#clients+1] = newname
        print('clients online')
        for i=1,#clients do
          print(clients[i])
          end
      end
      if(pheader == '006') then
        print('server updating map...')
        world = {}
        worldsize = tonumber(string.sub(data,1,1))
        worlddata = string.sub(data,2)
        world = World:new(worldsize,ratio)
        print('New world size ' .. worldsize .. ' ratio ' .. ratio)
        print(worlddata)
        chunksize = (worldsize/ratio)*(worldsize/ratio)
        chunks = (worldsize*worldsize)/chunksize
        for i = 1, chunks do
          chunkdata = string.sub(worlddata,1,chunksize)
          worlddata = string.sub(worlddata,chunksize)

          world:FillChunk(chunkdata, i)
        end
      end
      if(pheader == '007') then
        --print(data .. " disconnected")
        for i=1,#clients do
          if clients[i] == data then
            clients[i] = ''
          end
        end
      end
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

function NetTest:initialize()
  super.initialize(self)
  self:gotoState('Menu')
end

function love.load()
  netTest = NetTest:new()
end
