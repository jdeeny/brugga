local class = require 'lib.middleclass'
local Gamestate = require 'gamestates.gamestate'
local anim8 = require 'lib.anim8'
local Menu = require 'ui.menu'
local Score = require 'ui.score'

local Ending = class('Ending', Gamestate)

local function comma_value(amount)
  local formatted = amount
  local k = nil
  while true do
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted
end


function Ending:initialize(name)
  Gamestate.initialize(self, name)

  self.menu_height = 120
  self.menu_width = 1280
  self.menu_y = 580

  self.menu = Menu:new({
    { kind='text', label='Play Again', func=function()
      gameWorld.playerData:reset()
      gameWorld.gameState:setState('gameplay')
    end },
    { kind='text', label='Return to Menu', func=function() gameWorld.gameState:setState('title') end },
  }, self.menu_width, self.menu_height)

  self.losstags = {{'brugga'}, {'loss'}}
  self.endingtags = {{'brugga'}, {'ending'}}


  self.font_banner = gameWorld.assets.fonts.generic(90)
  self.font_heading = gameWorld.assets.fonts.generic(60)
  self.font_score = gameWorld.assets.fonts.generic(80)

  self.font_text = gameWorld.assets.fonts.generic(40)
  self.fade = 0.0

  self.margin = 40
  self.print_width = 1280 - 2 * self.margin

  self.banner_y = 10
  self.score_y = 120
  self.patrons_y = 220

  self.score_x = 650
  self.score_y = 250
  self.score_width = 300

  self.avatar_x = 190
  self.avatar_y = 240

  self.image = gameWorld.assets.sprites.brugga.BruggaRunningSheet
  local grid = anim8.newGrid(339, 265, self.image:getWidth(), self.image:getHeight(), 0, 0, 0)
  self.animation = anim8.newAnimation(grid('1-8',1), .1)
end

function Ending:enter()
  self.fade = 1.0
  flux.to(self, 2, { fade = 0.0 }):ease("quadinout")

  self.backsnow = require('ui.snow'):new()
  self.snow = require('ui.snow'):new()
  gameWorld.sound:playMusic('ending')

  if gameWorld.playerData.score > gameWorld.settings.config.high_score then
    gameWorld.settings.config.high_score = gameWorld.playerData.score
    gameWorld.settings:save()
  end

  if gameWorld.playerData.score < 0 then
    gameWorld.sound:playVoice(self.losstags)
  else
    gameWorld.sound:playVoice(self.endingtags)
  end
  self.score = Score:new(gameWorld.playerData.score, 80, 0):getDrawable()
  self.high_score = Score:new(gameWorld.settings.config.high_score, 80, 0):getDrawable()

end

function Ending:update(dt)
  self.menu:update(dt)
  self.animation:update(dt)
  self.backsnow:update(dt*0.9)
  self.snow:update(dt)
--[[  if gameWorld.playerInput:pressed('action') or gameWorld.playerInput:pressed('pour') then
    print("exit ending")
    gameWorld.gameState:setState('credits')
  end
  --]]
end

function Ending:draw()
  love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
  love.graphics.draw(gameWorld.assets.backdrops.title_background, 0, 0)
  ----- Backsnow
  self.backsnow:draw()
  ----- Banner
  love.graphics.setFont(self.font_banner)
  love.graphics.printf("What A Night!", self.margin, self.banner_y, self.print_width, 'center')

  love.graphics.setFont(self.font_heading)


  love.graphics.setColor(gameWorld.colors.score)
  love.graphics.setFont(self.font_score)

  --local score_str = comma_value(gameWorld.playerData.score) .. ".00"
  --love.graphics.printf("$", self.score_x, self.score_y, self.score_width, 'left')
  --love.graphics.printf(score_str, self.score_x, self.score_y, self.score_width, 'right')
  love.graphics.print("Total:", self.score_x, self.score_y - 90)
  love.graphics.draw(self.score, self.score_x, self.score_y)
  love.graphics.print("High Score:", self.score_x, self.score_y + 90)
  love.graphics.draw(self.high_score, self.score_x, self.score_y + 180)

  love.graphics.setColor(gameWorld.colors.white)

  --love.graphics.printf("Score:", self.margin, self.score_y, self.print_width, 'left')
  --love.graphics.printf("Served:", self.margin, self.patrons_y, self.print_width, 'left')
  --love.graphics.printf("Drinks:", self.margin, self.drinks_y, self.print_width, 'left')
  self.animation:draw(self.image, self.avatar_x, self.avatar_y)

  self.menu:draw(0, self.menu_y)
  ----- Frontsnow
  love.graphics.setColor(gameWorld.colors.white)
  self.snow:draw()
  ----- Fade
  if self.fade > 0 then
    love.graphics.setColor(0.0, 0.0, 0.0, self.fade)
    love.graphics.rectangle('fill', 0, 0, 1280, 720)
  end
end

return Ending
