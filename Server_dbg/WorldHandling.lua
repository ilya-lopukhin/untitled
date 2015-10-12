

world = ''
worldsize = 8
function love.update()
  math.randomseed(os.time())
end
function genWorld()
  world = ''
  for i=1,worldsize do
    for j = 1,worldsize do
      if math.random(1,100)>50 then
        world = world .. '0'
      else
        world = world .. '1'
      end
    end
  end
return world
end

