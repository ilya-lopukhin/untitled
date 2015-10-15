

Client = class('Client')


function Client:initialize(id,name)
  self.id = id
  self.name = name
  self.char = nil
  self.active = true
end