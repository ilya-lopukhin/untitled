local md5 = require 'md5'
local io = require('io')
local Menu = NetTest:addState('Menu')

function Menu:enterState()
  clearLoveCallbacks()

  client:setCallback(onReceive)
  
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
  
  
  function backtoMenu()
    messages = {}
    input = ''
    pass = ''
    register = 0
    step = 0
  end
  
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
      
  
  function updatemsgbox()
    for i = 1,#messages do
      love.graphics.print(messages[i], 0, i*mainfont:getHeight())
    end
  end
  
  function love.draw()
    startscreen:Draw()
    regscreen:Draw()
    updatemsgbox()
   --[[love.graphics.print(love.mouse.getX() .. ':' .. love.mouse.getY() , 100,0)
    if register == 1 then
        love.graphics.print(loginphrase, 0,0)
        love.keyboard.setTextInput(true)
        love.graphics.print(input, mainfont:getWidth(loginphrase)+1,0)
          if confirm then
            messages[#messages+1]=loginphrase .. " " .. input
            login = input
            love.keyboard.setTextInput(false)

            confirm = false
            input = ''
            text = nil
          end
    end
    if register == 2 then
        love.graphics.print(passphrase, 0,0)
        love.keyboard.setTextInput(true)
        love.graphics.print(input, mainfont:getWidth(passphrase)+1,0)
          if confirm then
            messages[#messages+1]=passphrase .. " " .. input
            pass = input
            love.keyboard.setTextInput(false)
            client:send('002' .. login .. "|" .. md5.sumhexa(pass))
            input = ''
            text = nil
            confirm = false
          end
    end
    if login_ then
      --messages[#messages+1] = loginphrase .. " " .. login
      love.graphics.print(loginphrase, 0,0)
      love.keyboard.setTextInput(true)
      love.graphics.print(input, mainfont:getWidth(loginphrase)+1,0)
      if confirm then
        messages[#messages+1]=loginphrase .. " " .. input
        login = input
        love.keyboard.setTextInput(false)
        input = ''
        chat[#chat+1] = "sup, " .. login
        text = nil
        step = 3
        login_ = false
        confirm = false
      end
    end
    if step == 3 then
     -- messages[#messages+1]=passphrase .. " " .. pass
     love.graphics.print(passphrase, 0,0)
     love.keyboard.setTextInput(true)
     love.graphics.print(input, mainfont:getWidth(passphrase)+1,0)
      if confirm then
        messages[#messages+1]=passphrase .. " " .. input
        pass = input
        love.keyboard.setTextInput(false)
        input = ''
        text = nil
        step = 4
        confirm = false
      end
    end]]--
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
  
end
