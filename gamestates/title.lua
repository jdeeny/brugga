local class = require 'lib.middleclass'
local Gamestate = require 'gamestates.gamestate'
local Menu = require 'ui.menu'
local anim8 = require 'lib.anim8'

local Title = class('Title', Gamestate)

function Title:initialize(name)
  Gamestate.initialize(self, name)

  self.title = love.graphics.newText(gameWorld.assets.fonts.title(100), 'Brugga the Brewer')

  self.menuWidth = 900
  self.menuHeight = 340
  self.brugga_x = 900
  self.brugga_y = 200

  self.animations = {}
  self.images = {}

  local brugga_arch = require('entities.archetypes.brugga')
  for name, anim in pairs(brugga_arch.animations) do
    self.animations[name] = anim8.newAnimation(anim.grid, anim.rate)
    self.images[name] = anim.image
  end

  self.anim = 'idle'

  self.menu = Menu:new({
    { kind='text', label='Credits', func=function()
      flux.to(self, 0.2, { fade = 1.0 }):oncomplete(function() gameWorld.gameState:setState('credits') end) end },

    { kind='text', label='Play Game', func=function()
      gameWorld.playerData:reset()
      gameWorld.gameState:setState('gameplay')
    end },
    { kind='slider', label='SFX', get=function() return gameWorld.sound.tags.sfx.volume end, set=function(value) gameWorld.sound:setSfxVolume(value) end },
    { kind='slider', label='Music', get=function() return gameWorld.sound.tags.music.volume end, set=function(value) gameWorld.sound:setMusicVolume(value) end },
    { kind='text', label='Exit to Desktop', func=function() gameWorld.settings:save() love.event.push('quit') end },
  }, self.menuWidth, self.menuHeight)

  self.fade = 0.0
end

function Title:enter()
  self.backsnow = require('ui.snow'):new()
  self.snow = require('ui.snow'):new()
  self.fade = 1.0
  flux.to(self, 1, { fade = 0.0 }):ease("quadinout")

  gameWorld.sound:playMusic('title')
end

function Title:draw()
  love.graphics.setColor(gameWorld.colors.white)
  love.graphics.clear(gameWorld.colors.title_background)
  love.graphics.draw(gameWorld.assets.backdrops.title_background, 0, 0)
  self.backsnow:draw()
  love.graphics.setColor(0.0,0.0,0.0,1.0)
  love.graphics.draw(self.title, (1280 - self.title:getWidth()) / 2, 100)
  love.graphics.setColor(1.0,1.0,1.0,1.0)

  self.animations[self.anim]:draw(self.images[self.anim], self.brugga_x, self.brugga_y)


  self.menu:draw((1280 - self.menuWidth) / 2, 720 - self.menuHeight - 100 )
  self.snow:draw()
  if self.fade > 0 then
    love.graphics.setColor(0.0, 0.0, 0.0, self.fade) --(0.0, 0.0, 0.0, self.fade)
    love.graphics.rectangle('fill', 0, 0, 1280, 720)
  end
end

function Title:exit()
  gameWorld.settings:save()
end

function Title:update(dt)
  self.backsnow:update(dt*0.9)
  self.snow:update(dt)
  self.menu:update(dt)
  self.animations[self.anim]:update(dt)
end


return Title
