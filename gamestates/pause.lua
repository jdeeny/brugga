local class = require 'lib.middleclass'
local Gamestate = require 'gamestates.gamestate'
local Menu = require'ui.menu'

local Pause = class('Pause', Gamestate)


function Pause:initialize(name)
  Gamestate.initialize(self, name)

  self.menu = Menu:new({
    { kind='text', label='Credits', func=function() gameWorld.gameState:setState('credits') end },
    { kind='text', label='Play Game', func=function() gameWorld.gameState:setState('gameplay') end },
    { kind='slider', label='SFX', get=function() return gameWorld.sound.tags.sfx:getVolume() end, set=function(value) gameWorld.sound.tags.sfx.setVolume(value) end },
    { kind='slider', label='Music', get=function() return gameWorld.sound.tags.music:getVolume() end, set=function(value) gameWorld.sound.tags.music.setVolume(value) end },
    { kind='text', label='Exit to Desktop', func=function() love.event.push('quit') end },
  })

end

function Pause:draw()
  love.graphics.setColor(1.0, 1.0, 1.0, 0.5)
  love.graphics.rectangle('fill', 350, 100, 1280-700, 720 - 200, 16, 16, 16)
  love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
  self.menu:drawAt(1280 / 2 - 150, 720 / 2 - 250, 300, 500)
end

function Pause:update(dt)
  self.menu:update(dt)
  if gameWorld.playerInput:pressed('pause') then
    print("exit pause")
    gameWorld.gameState:exitState()
  end
end

return Pause
