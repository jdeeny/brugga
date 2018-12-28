local class = require 'lib.middleclass'
local colors = require 'ui.colors'
local Text = require 'ui.text'
local Slider = require 'ui.slider'

local Menu = class('Menu')

function Menu:initialize(entries, w, h)
  local _entries = entries
  self.w = w or 500
  self.h = h or 300
  self.selected = 1
  self.font = gameWorld.assets.fonts.generic(42)
  self.vsize = self.h / #_entries
  self.vpad = 50
  self.hpad = 25
  self.segments = 10
  self.sprites = {
    left = gameWorld.assets.sprites.ui.selectorLeft,
    right = gameWorld.assets.sprites.ui.selectorRight,
    slideLeft = gameWorld.assets.sprites.ui.sliderLeft,
    slideRight = gameWorld.assets.sprites.ui.sliderRight,
  }

  for _, entry in ipairs(_entries) do
    if entry.kind == 'text' then
      entry.text = Text:new(entry.label, { halign='center', valign='center', font=self.font })
      entry.width = entry.text:getWidth()
    elseif entry.kind == 'slider' then
      entry.text = Text:new(entry.label, { halign='left', valign='center', font=self.font })
      entry.slider = Slider:new(0, 1.0, 10, entry.get())
      entry.width = entry.slider:getWidth() + self.hpad + entry.text:getWidth()
    end
  end
  self.entries = _entries

end

function Menu:update(dt)
  if gameWorld.playerInput:pressed('ok') then
    if self.entries[self.selected].kind == 'text' then
      gameWorld.sound:playUi('menuSelect')
      self.entries[self.selected].func()
    end
  elseif gameWorld.playerInput:pressed('down') then
    self.selected = self.selected + 1
    if self.selected > #self.entries then self.selected = 1 end
    gameWorld.sound:playUi('menuSwitch')
  elseif gameWorld.playerInput:pressed('up') then
    self.selected = self.selected - 1
    if self.selected == 0 then self.selected = #self.entries end
    gameWorld.sound:playUi('menuSwitch')
  elseif gameWorld.playerInput:pressed('left') then
    if self.entries[self.selected].slider then
      self.entries[self.selected].slider:lower()
      self.entries[self.selected].set(self.entries[self.selected].slider.value)
    end
  elseif gameWorld.playerInput:pressed('right') then
    if self.entries[self.selected].slider then
      self.entries[self.selected].slider:raise()
      self.entries[self.selected].set(self.entries[self.selected].slider.value)
    end
  end
end

function Menu:drawAt(x, y)
  love.graphics.setColor(colors.lightblue)
  for i, entry in ipairs(self.entries) do
    local y = i * self.vsize + y
    if entry.kind == 'text' then
      entry.text:draw(x, y, self.w, self.h)
      if i == self.selected then
        local c = x + self.w / 2
        local l = c - entry.width / 2 - self.hpad - self.sprites.left:getWidth()
        local r = c + entry.width / 2 + self.hpad
        love.graphics.draw(self.sprites.left, l, y + self.vsize / 2 - self.sprites.left:getHeight() / 2)
        love.graphics.draw(self.sprites.right, r, y + self.vsize / 2 - self.sprites.right:getHeight() / 2)
      end
    elseif entry.kind == 'slider' then
      entry.text:draw(x + self.w / 2 - entry.width / 2, y, entry.text:getWidth(), self.h)
      entry.slider:draw(x + self.w / 2 + entry.width / 2 - entry.slider:getWidth(), y + self.vsize / 2 - entry.slider:getHeight() / 2)
      if i == self.selected then
        local c = x + self.w / 2
        local l = c - entry.width / 2 - self.hpad - self.sprites.slideLeft:getWidth()
        local r = c + entry.width / 2 + self.hpad
        love.graphics.draw(self.sprites.slideLeft, l, y + self.vsize / 2 - self.sprites.slideLeft:getHeight() / 2)
        love.graphics.draw(self.sprites.slideRight, r, y + self.vsize / 2 - self.sprites.slideRight:getHeight() / 2)
      end
    end



  end
end


return Menu
