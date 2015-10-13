
local md5 = require 'md5'
local io = require('io')
local Menu = Lamp:addState('Menu')

function Menu:enterState()
  clearLoveCallbacks()
  
  button1 = Button:new(love.graphics.newImage('sprites/loginbutton.png'),love.graphics.newImage('sprites/loginbuttonpressed.png'),true)
  button2 = Button:new(love.graphics.newImage('sprites/registerbutton.png'),love.graphics.newImage('sprites/registerbuttonpressed.png'),true)
  greetLabel = Image:new(love.graphics.newImage('sprites/greetLabel.png'))
  loginLabel = Image:new(love.graphics.newImage('sprites/loginLabel.png'))
  loginbox = InputBox:new(love.graphics.newImage('sprites/inputBox.png'),'Enter login here')
  passLabel = Image:new(love.graphics.newImage('sprites/passLabel.png'))
  passbox = InputBox:new(love.graphics.newImage('sprites/inputBox.png'),'Enter pass here')
  testTextLabel = TextLabel:new('test text')
  
  regLabel = Image:new(love.graphics.newImage('sprites/registerLabel.png'))
  regloginbox = InputBox:new(love.graphics.newImage('sprites/inputBox.png'),'Enter login here')
  regpassbox = InputBox:new(love.graphics.newImage('sprites/inputBox.png'),'Enter pass here')
  regbutton = Button:new(love.graphics.newImage('sprites/doneButton.png'),love.graphics.newImage('sprites/registerbuttonpressed.png'),true)
  
   function love.update(dt)
         client:update(dt)
    if curr_input == loginbox then
      curr_input:TakeInput(input)
      login = curr_input:GetInput()
    end
    if curr_input == passbox then
      curr_input:TakeInput(input)
      pass = curr_input:GetInput()
    end
    if curr_input == regloginbox then
      curr_input:TakeInput(input)
      login = curr_input:GetInput()
    end
    if curr_input == regpassbox then
      curr_input:TakeInput(input)
      pass = curr_input:GetInput()
    end
  end
  
--Creating Menu GUI Block  
    startscreenW = greetLabel.image:getWidth()
    regscreenW = regLabel.image:getWidth()
    startscreen = Block:new(love.graphics.getWidth()/2,love.graphics.getHeight()/2,2,startscreenW,256)
      startscreen:addElement(0, 0, greetLabel)
      startscreen:addElement(startscreenW/8, 16, button1)
      startscreen:addElement(startscreenW/8, 16, button2)
      startscreen:addElement(startscreenW/8, 16, loginbox)
      startscreen:addElement(startscreenW/8, 16, loginLabel)
      startscreen:addElement(startscreenW/8, 16, passbox)
      startscreen:addElement(startscreenW/8, 16, passLabel)
    regscreen = Block:new(love.graphics.getWidth()/2,love.graphics.getHeight()/2,2,startscreenW,256)
      regscreen:addElement(0,0,regLabel)
      regscreen:addElement(regscreenW/8, 16, regloginbox)
      regscreen:addElement(regscreenW/8, 16, loginLabel)
      regscreen:addElement(regscreenW/8, 16, regpassbox)
      regscreen:addElement(regscreenW/8, 16, passLabel)
      regscreen:addElement(regscreenW/4, 16, regbutton)
      regscreen:Visible(false)
-------------------------
  
      
  function love.draw()
    startscreen:Draw()
    regscreen:Draw()
  end
  
  function love.mousepressed(x,y,button)
    if button == 'l' then 
      if button2:Pressed(x,y) then
        startscreen:Visible(false)
        regscreen:Visible(true)
      end
      if regbutton:Pressed(x,y) then
          if loginfree then
            client:send('002' .. login .. "|" .. md5.sumhexa(pass))
            client:send('000' .. login .. "|" .. md5.sumhexa(pass))
          end
      end
      if button1:Pressed(x,y) then
        if login ~= nil then
          if pass ~=nil then
            client:send('000' .. login .. "|" .. md5.sumhexa(pass))
            client:send('004')
          else
            print('ENTER PASS PLS')
          end
        else
          print('ENTER LOGIN PLS')
        end
      end
      if loginbox:Pressed(x,y) then
        input = ''
        curr_input = loginbox
      end
      if passbox:Pressed(x,y) then
        input = ''
        curr_input = passbox
      end
      if regloginbox:Pressed(x,y) then
        input = ''
        curr_input = regloginbox
      end
      if regpassbox:Pressed(x,y) then
        if login ~= '' then
          client:send('001' .. login)
          input = ''
          curr_input = regpassbox
        else 
          regloginbox:setText('Please input login first')
        end
      end
    end
  end
  
  function love.mousemoved(x,y,dx,dy)
      if button2:Pressed(x,y) then
      end
      if button1:Pressed(x,y) then
      end
  end
  function love.keypressed(k,u)
    if k=='escape' then
      love.event.push('q')
    end
    if k=='return' then
      print(login)
      print(pass)
    end
    if k == "backspace" then
       local byteoffset = utf8.offset(input, -1)
        if byteoffset then
            input = string.sub(input, 1, byteoffset - 1)
        end
    end
  end 
end
function Menu:exitState()
  print("Exiting menu")
end
