local driver = require("luasql.mysql")
local env = driver.mysql()
local Server = NetTest:addState('Server')
      genWorld = false

  function Server:enterState()
    
    clearLoveCallbacks()
    print("initializing server")
    clients = {}
    chat = {}
    chars = {}
    query_t = {}
    query_f = {}
    time = 0
    online = 0
  
  function onConnect(ip, port)
    print("Connection from " .. ip)
    clients[ip] = Client:new(math.random(10001,99999),'noname')
    print(clients[ip].id .. ' id to new client ' .. clients[ip].name)
    print(#clients .. ' online')
  end
  
  function onReceive(data, ip, port)
    
    local pheader = string.sub(data,1,3)
    local data = string.sub(data,4)
    
    if(pheader == '000') then
      print('someone authorizing with ' .. data .. ' token')
      sep = string.find(data,'|')
      authlogin = string.sub(data,1,sep-1)
      authpass  = string.sub(data,sep+1)
      conn = env:connect('LUADB', 'root', 'Kolokolq11')
      query = conn:execute('SELECT `Login`, `Pass` FROM `Users` WHERE `Login` = "' .. authlogin .. '" AND `Pass` = "' .. authpass .. '" ')
      row = query:fetch({},'a')
      if row ~= nil then
        print(ip .. ' passed auth ' .. row.Login .. ' == ' .. authlogin .. "|" .. row.Pass .. " == " .. authpass)
        --remember new auth's login
        clients[ip].name = authlogin
        --send world to new auth
        MainWorld:sendChunk(1,ip)
        --create a sphere for new auth
        clients[ip].char = Character:new(0,0)
        --send all data about existing players to new auth
       for i = 1,#clients do
         if clients[i] ~= nil then
         if clients[i].id ~= clients[ip].id then
          server:send('005' .. clients[i].id .. clients[i].name, ip)
         end
       end
       end
        --send system message "new username connected"
       server:send('004' .. '10000' .. authlogin .. ' connected')
        --grant access to the server to the new arrival
       server:send('003',ip)
        --send id/name of new arrival to all
       server:send('005' .. clients[ip].id .. clients[ip].name)
      else
        server:send('000',ip)
      end
        conn:close()
        query = nil
        passed = nil
    end
    
    if(pheader == '001') then
        newlogin = data
        print('someone registering with login ' .. newlogin)
        conn = env:connect('LUADB', 'root', 'Kolokolq11')
        query = conn:execute('SELECT `Login` FROM `Users` WHERE `Login` = "' .. newlogin .. '"')
        query = query:fetch()
        if query == newlogin then
          print(newlogin .. ' is already registered')
          server:send('000',ip)
        end
        if query == nil then
            print(newlogin .. ' is free')
            server:send('001',ip)
        end
        conn:close()
        query = nil
    end
  
    if(pheader == '002') then
      local sep = string.find(data,'|')
      local newlogin = '"' .. string.sub(data,1,sep-1) .. '"'
      local newpass = '"' .. string.sub(data,sep+1) .. '"'
      local conn = env:connect('LUADB', 'root', 'Kolokolq11')
      local query = conn:execute('INSERT INTO Users VALUES(' .. newlogin .. ',' .. newpass ..');')
      conn:close()
      server:send('002',ip)
      end
      
    if(pheader == '003') then
      local message = data
      if clients[ip].id ~= nil then
        print('recieved chat messgage : ' .. message .. ' from ' .. clients[ip].id)
      end
      chat[#chat+1] = message
      if clients[ip].id ~= nil then
        server:send('004' .. clients[ip].id .. data)
      else
        print('WARNING client_id[' .. ip .. '] is nil')
      end
    end
    if(pheader == '005') then
      local sep = string.find(data,'|')
      clients[ip].char.x = string.sub(data,1,sep-1)
      clients[ip].char.y = string.sub(data,sep+1)
      server:send('008' .. clients[ip].id .. '|' .. clients[ip].char.x .. '|' .. clients[ip].char.y)
    end
    if(pheader == '006') then
      clients[ip].active = true
    end
end

    
  function onDisconnect(ip, port)

  end
  
  server = lube.server(3557)
  server:setCallback(onReceive, onConnect, onDisconnect)
  server:setHandshake("Hi!")
  print("initialized server")
  
  function love.update(dt)
    time = time + 1
    server:update(dt)
    if time == 150 then
      for i = 1, #clients do
        if clients[i] then
        if clients[i].active == false then
          print(clients[i].id .. ' disconnected')
          onDisconnect(i)
          server:send('007' .. clients[i].id)
          table.remove(clients,i)
          table.remove(server.clients,i)
          print(#clients .. ' clients online')
        else
          clients[i].active = false
        end
        end
      end
      time = 0
    end
  end
  function love.draw()
  end
  function love.keypressed(k)
    if k=='escape' then
      netTest:gotoState('Menu')
    end
  end
end
function Server:exitState()
  --TODO: Server EXIT CODE
  print("Exiting server")
end
