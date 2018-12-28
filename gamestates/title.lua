local class = require 'lib.middleclass'
local Gamestate = require 'gamestates.gamestate'
local Menu = require'ui.menu'

local Title = class('Title', Gamestate)

function Title:initialize(name)
  Gamestate.initialize(self, name)

  self.menu = Menu:new({
    { kind='text', label='Credits', func=function() gameWorld.gameState:setState('credits') end },
    { kind='text', label='Play Game', func=function() gameWorld.gameState:setState('gameplay') end },
    { kind='slider', label='SFX', get=function() return gameWorld.sound.tags.sfx:getVolume() end, set=function(value) gameWorld.sound.tags.sfx.setVolume(value) end },
    { kind='slider', label='Music', get=function() return gameWorld.sound.tags.music:getVolume() end, set=function(value) gameWorld.sound.tags.music.setVolume(value) end },
    { kind='text', label='Exit to Desktop', func=function() love.event.push('quit') end },
  })

end

function Title:draw()
  love.graphics.setColor(1.0,1.0,1.0,1.0)
  love.graphics.rectangle('fill', 20, 10, 60, 20)
  self.menu:drawAt(1280 / 2 - 150, 720 / 2 - 250, 300, 500)
end

function Title:update()
  self.menu:update(dt)

--[[  if gameWorld.playerInput:pressed 'ok' then
    print("exit title")
    gameWorld.gameState:setState('gameplay')
  end]]
end


return Title
