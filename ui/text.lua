local class = require 'lib.middleclass'

local Text = class('Text')

function Text:initialize(text, options)
  self.options = {
    halign = options.halign or 'left',
    valign = options.valign or 'top',
    font = options.font or gameWorld.assets.fonts.generic(16)
  }
  self.text = love.graphics.newText(self.options.font, text)
end

function Text:getWidth()
  return self.text:getWidth()
end

function Text:getHeight()
  return self.text:getHeight()
end

function Text:draw(x, y, w, h)
  local _x = x
  local _y = y
  if w and self.options.halign == 'center' then
    _x = (w - self:getWidth()) / 2 + x
  end
  if w and self.options.halign == 'right' then
    _x = w - self:getWidth()
  end

  if h and self.options.valign == 'center' then
      local _y = (h - self:getHeight()) / 2 + y
  end
  if h and self.options.valign == 'bottom' then
    _y = y + h - self:getWidth()
  end

  love.graphics.draw(self.text, _x, _y)
end

return Text
