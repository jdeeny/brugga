local class = require 'lib.middleclass'
local colors = require 'ui.colors'
local Text = require 'ui.text'
local Slider = require 'ui.slider'

local Menu = class('Menu')

function Menu:initialize(entries)
  local _entries = entries
  self.selected = 1
  self.font = gameWorld.assets.fonts.generic(16)
  self.vpad = 30
  self.hpad = 15
  self.segments = 10
  self.sprites = {
    left = gameWorld.assets.sprites.ui.selectorLeft,
    right = gameWorld.assets.sprites.ui.selectorRight,
    slideLeft = gameWorld.assets.sprites.ui.sliderLeft,
    slideRight = gameWorld.assets.sprites.ui.sliderRight,
  }

  self.width = 500

  for _, entry in ipairs(_entries) do
    entry.text = Text:new(entry.label, { halign='center' }) --, font=self.font })
    pretty.dump(entry)

    if entry.kind == 'text' then
      entry.width = entry.text:getWidth()
    elseif entry.kind == 'slider' then
      entry.slider = Slider:new(entry.text, 0, 1.0, 10, entry.get())
      entry.width = entry.slider:getWidth()
    end
  end
  self.entries = _entries

end

function Menu:update(dt)
  if gameWorld.playerInput:pressed('ok') then
    if self.entries[self.selected].kind == 'text' then
      self.entries[self.selected].func()
    end
  elseif gameWorld.playerInput:pressed('down') then
    self.selected = self.selected + 1
    if self.selected > #self.entries then self.selected = 1 end
  elseif gameWorld.playerInput:pressed('up') then
    self.selected = self.selected - 1
    if self.selected == 0 then self.selected = #self.entries end
  elseif gameWorld.playerInput:pressed('left') then
    if self.entries[self.selected].slider then
      self.entries[self.selected].slider:lower()
    end
  elseif gameWorld.playerInput:pressed('right') then
    if self.entries[self.selected].slider then
      self.entries[self.selected].slider:raise()
    end
  end
end

function Menu:drawAt(x, y, w, h)
  love.graphics.setColor(colors.lightblue)
  for i, entry in ipairs(self.entries) do
    local y = i * 30 + y
    if entry.kind == 'text' then
      entry.text:draw(x + self.sprites.left:getWidth() + self.hpad, y, w, h)
      if i == self.selected then
        love.graphics.draw(self.sprites.left, x, y)
        love.graphics.draw(self.sprites.right, x + self.width - self.sprites.right:getWidth(), y)
      end
    elseif entry.kind == 'slider' then
      entry.slider:draw(x + self.sprites.left:getWidth() + self.hpad, y)
      if i == self.selected then
        love.graphics.draw(self.sprites.slideLeft, x, y)
        love.graphics.draw(self.sprites.slideRight, x + self.width - self.sprites.right:getWidth(), y)
      end
    end



  end
end


return Menu
