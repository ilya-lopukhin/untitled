
local Menu = NetTest:addState('Menu')
function Menu:enterState()
  clearLoveCallbacks()
  menuText = "press 1 to host"
  function love.draw()
    love.graphics.print(menuText, 0,0)
  end
  function love.keypressed(k,u)
    if k=='1' then
      netTest:gotoState('Server')
    end
  end 
end
function Menu:exitState()
  
end
