
local Game = Lamp:addState('Game')
local time = 0
local time1 = 0
function Game:enterState()
  
  clearLoveCallbacks()
  print("initializing client")
  
  grass = love.graphics.newImage('sprites/grass.png')
  rocks = love.graphics.newImage('sprites/rocks.png')
  brick = love.graphics.newImage('sprites/brick.png')
  selection = love.graphics.newImage('sprites/selection.png')
  char = Character:new(0,0,love.graphics.newImage('sprites/sphere.png'))

  
--------------------GUI-------------------
  chatbox = Block:new(0,0,0,love.window.getWidth()/4,200)
  online = Block:new(love.window.getWidth()-love.window.getWidth()/4,0,0,100,love.window.getWidth()/4)
------------------------------------------
   function love.update(dt)
     time = time + 1
     time1 = time1 + 1
     client:update(dt)
     if time1 == 30 then
      client:send('006')
      time1 = 0
     end
     if(#chat > 15) then
       chat[1] = nil
       for i = 1,15 do
         chat [i] = chat[i+1]
       end
       chat[16] = nil
     end
    if time == 1 then
      for i = 1, #client_id do
        chars[client_id[i]]:Move(1)
      end
      time = 0
    end
  end
------------------------------------------  
  function love.draw()
    cam:attach()
    
      MainWorld:Draw()
      for i = 1 , #client_id do
        chars[client_id[i]]:Draw()
      end

    cam:detach()
    chatbox:Draw()
    online:Draw()
    if input_line == 1 then
      love.graphics.printf(input,0,8+(#chat+1)*mainfont:getHeight( ),love.graphics.getWidth())
      love.graphics.printf('|',mainfont:getWidth(input)+1,8+(#chat + 1)*mainfont:getHeight( ),love.graphics.getWidth())
    end
    for i = 1,#chat do
      love.graphics.printf(chat[i], 0, 8+i*mainfont:getHeight( ), love.graphics.getWidth())
    end
  end
-----------------------------------------
  function love.mousepressed(x, y, button)
    if button == 'r' then
      local mx , my = cam:mousepos()
      char:MoveTo(mx,my)
      client:send('005' .. char.moveTrg.x .. '|' .. char.moveTrg.y)
    end
  end
  function love.mousemoved( x, y, dx, dy )
    if love.mouse.isDown('l') then
     cx, cy = cam:pos()
     mx , my = cam:mousepos()
    cam:lookAt(cx-dx, cy-dy)
    end
  end
------------------------------------------
  function love.keypressed(k)
    if k=='escape' then
      netTest:gotoState('Menu')
    end
    if k == 'y' then
      love.keyboard.setTextInput(true)
      input_line = 1
    end
    if k == 'return' and input_line == 1 then
      client:send('003' .. input)
      love.keyboard.setTextInput(false)
      input_line = 0
      input = ''
    end
    if k == "backspace" then
        local byteoffset = utf8.offset(input, -1)
        if byteoffset then
            input = string.sub(input, 1, byteoffset - 1)
        end
    end
  end
----------------------------------------- 
  function Game:exitState()
    print("Exiting client")
  end
end


