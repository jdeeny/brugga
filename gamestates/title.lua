local class = require 'lib.middleclass'
local Gamestate = require 'gamestates.gamestate'
local Menu = require'ui.menu'

local Title = class('Title', Gamestate)

function Title:initialize(name)
  Gamestate.initialize(self, name)

  self.title = love.graphics.newText(gameWorld.assets.fonts.title(120), 'Game Title')

  self.menuWidth = 900
  self.menuHeight = 340

  self.menu = Menu:new({
    { kind='text', label='Credits', func=function() gameWorld.gameState:setState('credits') end },
    { kind='text', label='Play Game', func=function() gameWorld.gameState:setState('gameplay') end },
    { kind='slider', label='SFX', get=function() return gameWorld.sound.tags.sfx.volume end, set=function(value) gameWorld.sound.tags.sfx.volume = value end },
    { kind='slider', label='Music', get=function() return gameWorld.sound.tags.music.volume end, set=function(value) gameWorld.sound.tags.music.volume = value end },
    { kind='text', label='Exit to Desktop', func=function() love.event.push('quit') end },
  }, self.menuWidth, self.menuHeight)

end

function Title:draw()
  love.graphics.clear(1.0,1.0,1.0,1.0)
  love.graphics.setColor(0.0,0.0,0.0,1.0)
  love.graphics.draw(self.title, (1280 - self.title:getWidth()) / 2, 100)
  love.graphics.setColor(1.0,1.0,1.0,1.0)
  self.menu:drawAt((1280 - self.menuWidth) / 2, 720 - self.menuHeight - 200 )
end

function Title:update()
  self.menu:update(dt)

--[[  if gameWorld.playerInput:pressed 'ok' then
    print("exit title")
    gameWorld.gameState:setState('gameplay')
  end]]
end


return Title
