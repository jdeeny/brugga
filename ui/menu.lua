local class = require 'lib.middleclass'
local colors = require 'ui.colors'
local Text = require 'ui.text'
local Slider = require 'ui.slider'

local Menu = class('Menu')
local PI = 3.14159

function Menu:initialize(entries, w, h)
  local _entries = entries
  self.x = 1
  self.y = 1
  self.w = w or 700
  self.h = h or 350
  self.selected = 1
  self.font = gameWorld.assets.fonts.generic(42)
  self.vsize = self.h / #_entries
  self.vpad = 50
  self.spin = 0
  self.hpad = 25
  self.segments = 10
  self.sprites = {
    left = gameWorld.assets.sprites.ui.selectorLeft,
    right = gameWorld.assets.sprites.ui.selectorRight,
    slideLeft = gameWorld.assets.sprites.ui.selectorLeft,
    slideRight = gameWorld.assets.sprites.ui.selectorRight,
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

  self.last_mouse = { love.mouse.getPosition() }

end

function Menu:update(dt)
  local current_entry = self.entries[self.selected]

  local m_pos = { love.mouse.getPosition() }
  local dx = m_pos[1] - self.last_mouse[1]
  local dy = m_pos[2] - self.last_mouse[2]
  if math.sqrt(dx*dx+dy*dy) > 2 or gameWorld.playerInput:pressed('mb1') then
    self.last_mouse = m_pos
    self:cursorInside()
  end

  if gameWorld.playerInput:pressed('action') then
    if gameWorld.playerInput:pressed('mb1') and not self:cursorInside() then
      return
    end

    if current_entry.kind == 'text' then
      gameWorld.sound:playUi('menuSelect')
      flux.to(self, 0.5, { spin = 1.0 }):oncomplete(function() self.spin = 0 end):oncomplete(current_entry.func)
    end
  elseif gameWorld.playerInput:pressed('down') then
    gameWorld.sound:playUi('menuSwitch')
    self.selected = self.selected + 1
    if self.selected > #self.entries then self.selected = 1 end
  elseif gameWorld.playerInput:pressed('up') then
    gameWorld.sound:playUi('menuSwitch')
    self.selected = self.selected - 1
    if self.selected == 0 then self.selected = #self.entries end
  elseif gameWorld.playerInput:pressed('left') then
    if current_entry.slider then
      if current_entry.label == 'Music' then
        gameWorld.sound:playUi('musicDecrease')
      else
        gameWorld.sound:playUi('volumeDecrease')
      end
      current_entry.slider:lower()
      current_entry.set(current_entry.slider.value)
    end
  elseif gameWorld.playerInput:pressed('right') then
    if current_entry.slider then
      if current_entry.label == 'Music' then
        gameWorld.sound:playUi('musicIncrease')
      else
        gameWorld.sound:playUi('volumeIncrease')
      end
      current_entry.slider:raise()
      current_entry.set(current_entry.slider.value)
    end
  end
end

function Menu:draw(x, y)
  self.x = x
  self.y = y
  for i, entry in ipairs(self.entries) do
    local _y = (i - 1) * self.vsize + y
    if entry.kind == 'text' then
      love.graphics.setColor(colors.menu_text)
      entry.text:draw(x, _y, self.w, self.h)
      if i == self.selected then
        local c = x + self.w / 2
        local l = c - entry.width / 2 - self.hpad - self.sprites.left:getWidth()
        local r = c + entry.width / 2 + self.hpad
        love.graphics.setColor(colors.white)
        love.graphics.draw(self.sprites.left, l + self.sprites.left:getWidth()/2, _y + self.vsize / 2 - 4, PI * 2 * self.spin, 1, 1, self.sprites.left:getWidth()/2, self.sprites.left:getHeight()/2)
        love.graphics.draw(self.sprites.right, r + self.sprites.right:getWidth()/2, _y + self.vsize / 2 - 4, 0 - PI * 2 * self.spin, 1, 1, self.sprites.right:getWidth()/2, self.sprites.right:getHeight()/2)
      end
    elseif entry.kind == 'slider' then
      love.graphics.setColor(colors.menu_text)
      entry.text:draw(x + self.w / 2 - entry.width / 2, _y, entry.text:getWidth(), self.h)
      love.graphics.setColor(colors.white)
      entry.slider:draw(x + self.w / 2 + entry.width / 2 - entry.slider:getWidth(), _y + self.vsize / 2 - entry.slider:getHeight() / 2)
      if i == self.selected then
        local c = x + self.w / 2
        local l = c - entry.width / 2 - self.hpad - self.sprites.slideLeft:getWidth()
        local r = c + entry.width / 2 + self.hpad
        love.graphics.draw(self.sprites.slideLeft, l, _y + self.vsize / 2 - self.sprites.slideLeft:getHeight() / 2 - 4)
        love.graphics.draw(self.sprites.slideRight, r, _y + self.vsize / 2 - self.sprites.slideRight:getHeight() / 2 - 4)
      end
    end



  end
end

function Menu:cursorInside()
  local x = self.last_mouse[1]
  local y = self.last_mouse[2]

  if x > self.x + 5 and x < self.x + self.w - 5 then
    if y > self.y + 5 and y < self.y + self.h - 5 then
      self.selected = math.floor((y - self.y) / self.vsize) + 1
      return true
    else
      return false
    end
  end

end

return Menu
