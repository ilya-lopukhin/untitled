--GUI handling module
local Width = love.graphics.getWidth()
local Height = love.graphics.getHeight()
local blocks = {}
local buttons = {}
local input = ''

loginphrase = 'Enter login '
passphrase = 'Enter pass '

 Block = class('Block')
 Element = class('Element')
 Image = class('Image',Element)
 Button = class('Button', Image)
 InputBox = class('InputBox',Image)
 TextLabel = class('TextLabel',Element)

function Block:initialize(x,y,border,width,height)
  self.border = border
  self.width = width
  self.height = height
  self.x = x - self.width/2
  self.y = y - self.height/2
  self.elements = {}
  self.visible = true
  self.flag = true
end

function Element:initialize()
  self.x = 0
  self.y = 0
end

function Image:initialize(image)
  Element.initialize(self)
  self.image = image
  self.width = image:getWidth()
  self.height = image:getHeight()
  self.visible = true
end

function Button:initialize(image, p_image,pressable)
  Image.initialize(self, image)
  self.p_image = p_image
  self.pressable = pressable
  self.visible = true
end


function Button:Pressed(x, y)
    if self.x < x and self.y < y and self.x + self.width  > x and self.y + self.height > y and self.visible then
      return true
    else
      return false
    end 
end

function InputBox:initialize(image,def_text)
  Image.initialize(self,image)
  if def_text ~= nil then
    self.text = def_text
  else
    self.text = ''
  end
end

function InputBox:Pressed(x, y)
  if self.x < x and self.y < y and self.x + self.width  > x and self.y + self.height > y then
    return true
  end
    return false
end

function InputBox:TakeInput(input)
  love.keyboard.setTextInput(true)
  self.text = input
end

function InputBox:GetInput()
  self.toreturn = self.text
  return self.toreturn
end
function InputBox:setText(text)
  self.text = text
end

function TextLabel:initialize(text)
  self.text = text
  self.height = mainfont:getHeight()
  self.width = mainfont:getWidth(self.text)
end

function Block:addElement(x,y,element)
  self.elements[#self.elements+1] = element
  self.elements[#self.elements].x = x
  self.elements[#self.elements].y = y
end

function Block:Visible(flag)
  self.visible = flag
  for i = 1,#self.elements do
    self.elements[i].visible = flag
  end
end

function Block:Draw()
    local drawer_x = self.x
    local drawer_y = self.y
  if self.visible then
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    for i=1,#self.elements do
        el_x = self.elements[i].x
        el_y = self.elements[i].y
        el_image = self.elements[i].image
        el_width = self.elements[i].width
        el_height = self.elements[i].height
        el_text = self.elements[i].text
        if i>1 then
          prevEl_height = self.elements[i-1].image:getHeight()
        end
        if drawer_x+el_width <= self.x+self.width then
          if i < #self.elements and self.flag then
            self.elements[i].x = drawer_x + el_x
            self.elements[i].y = drawer_y + el_y
          elseif i == #self.elements and self.flag then
            self.elements[i].x = drawer_x + el_x
            self.elements[i].y = drawer_y + el_y       
            self.flag = false
          end
          if el_image ~= nil then
            love.graphics.draw(el_image ,self.elements[i].x,self.elements[i].y)
          end
          if el_text ~= nil then
            love.graphics.print(el_text ,self.elements[i].x,self.elements[i].y)
          end
          drawer_x = drawer_x + el_width + self.border  
        else
          drawer_y = drawer_y + prevEl_height + self.border
          drawer_x = self.x
          if i < #self.elements and self.flag then
            self.elements[i].x = drawer_x + el_x
            self.elements[i].y = drawer_y + el_y
          elseif i == #self.elements and self.flag then
            self.elements[i].x = drawer_x + el_x
            self.elements[i].y = drawer_y + el_y      
            self.flag = false
          end
        if el_image ~= nil then
          love.graphics.draw(el_image ,self.elements[i].x,self.elements[i].y)
        end
        if el_text ~= nil then
          love.graphics.print(el_text ,self.elements[i].x,self.elements[i].y)
        end
        drawer_x = drawer_x + el_width + self.border
      end
    end
  end
  
end