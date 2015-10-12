
function Register:enterState()
  clearLoveCallbacks()
  function love.draw()
        love.graphics.print(loginphrase, 0,0)
        love.keyboard.setTextInput(true)
        love.graphics.print(input, Font:getWidth(loginphrase)+1,0)
          if confirm then
            love.keyboard.setTextInput(false)
            messages[#messages+1]=loginphrase .. " " .. input
            login = input
            client:send('1' .. input)
            input = ''
            confirm = false
            register = 1
          end
        if register == 1 then
          love.graphics.print(passphrase, 0,0)
          love.keyboard.setTextInput(true)
          love.graphics.print(input, Font:getWidth(passphrase)+1,0)
            if confirm then
              love.keyboard.setTextInput(false)
              messages[#messages+1]=passphrase .. " " .. input
              pass = input
              client:send('2' .. login .. "|" .. md5.sumhexa(pass))
              input = ''
              confirm = false
          end
        end
  end