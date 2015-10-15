

function onReceive(data)
      
     local pheader = string.sub(data,1,3)
     local data = string.sub(data,4)
     print('RECIEVED ' .. data .. ' WITH HEADER ' .. pheader .. ' FROM SERVER')
     
      if(pheader == '000') then
        print('auth failed or user already exists')
        backtoMenu()
      end
      if(pheader == '001') then
        print('login is free')
        local loginfree = true
      end
      if(pheader == '002') then
        print('User ' .. login .. ' registered')
      end
      if(pheader == '003') then
        print('auth passed')
        Lamp:gotoState('Game')
      end
      if(pheader == '004') then
        local sender = string.sub(data,1,5)
        local message = string.sub(data, 6)
       -- print('new message ' .. message .. ' from ' .. client_name[sender]) 
        if sender == '10000' then
          chat[#chat+1] = "System message : " .. message
        else
          chat[#chat+1] = client_names[sender] .. " : " .. message
        end
      end
      if(pheader  == '005') then
        local newid = string.sub(data,1,5)
        local newname = string.sub(data,6)
        client_id[#client_id+1] = newid
        client_names[newid] = newname
        print('new client with id ' .. client_id[#client_id] .. ' and name ' .. client_names[client_id[#client_id]])
        chars[newid] = Character:new(0,0,love.graphics.newImage('sprites/sphere1.png'))
      end
      if(pheader == '006') then
       print('server sent some worlddata')
       print(data)
       local dir = {tonumber(string.sub(data,1,1)),tonumber(string.sub(data,2,2))}
       data = string.sub(data,3)
       MainWorld:NewChunk(dir,stirng)
      end
      if(pheader == '007') then
        print(data .. " disconnected")
        client_names[data] = nil
        chars[data] = nil
        for i=1, #client_id do
          if client_id[i] == data then client_id[i] = nil break end
        end
      end
      if(pheader == '008') then
        local sep = string.find(data,'|')
        local id = string.sub(data,1,sep-1)
        data = string.sub(data,sep+1)
        sep = string.find(data, '|')
        local x = tonumber(string.sub(data,1,sep-1))
        local y = tonumber(string.sub(data,sep+1))
       --print('new position (' .. x .. ',' .. y .. ') of player ' .. id)
        chars[id]:MoveTo(x,y)
      end
    end
    
  client = lube.client()
  client:setHandshake("Hi!")
  client:setCallback(onReceive)
  connected = client:connect("127.0.0.1", 3557)
  print("initialized client")
  
  function love.update(dt)
    client:update(dt)
  end