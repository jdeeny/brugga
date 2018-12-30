local class = require 'lib.middleclass'

local Outline = class('Outline')

function Outline:initialize(font, outline, color, backcolor)
  self.font = font
  self.outline = outline or 2
  self.color = color or { 1.0, 1.0, 1.0, 1.0 }
  self.backcolor = backcolor or { 1.0, 1.0, 1.0, 1.0 }
end

function Outline:getOutline(text, color, backcolor)
  local color = color or self.color
  local backcolor = backcolor or self.backcolor
  local text = love.graphics.newText(self.font, text, 1.0, 1.0, 1.0, 1.0)

  local canvas = love.graphics.newCanvas(text:getWidth() + self.outline * 2, text:getHeight() + self.outline * 2)

  love.graphics.setCanvas(canvas)
  love.graphics.setColor(backcolor)
  love.graphics.draw(text, 0, 0)
  love.graphics.draw(text, self.outline, 0)
  love.graphics.draw(text, self.outline*2, 0)

  love.graphics.draw(text, 0, self.outline)
  love.graphics.draw(text, self.outline*2, self.outline)

  love.graphics.draw(text, 0, self.outline*2)
  love.graphics.draw(text, self.outline, self.outline*2)
  love.graphics.draw(text, self.outline*2, self.outline*2)

  love.graphics.setColor(color)
  love.graphics.draw(text, self.outline, self.outline)
  love.graphics.setCanvas()
  love.graphics.setColor(1.0,1.0,1.0,1.0)
  return canvas
end

return Outline
