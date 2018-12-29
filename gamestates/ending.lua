local class = require 'lib.middleclass'
local Gamestate = require 'gamestates.gamestate'

local Ending = class('Ending', Gamestate)

function Ending:initialize(name)
  Gamestate.initialize(self, name)

  self.font_banner = gameWorld.assets.fonts.generic(100)
  self.font_heading = gameWorld.assets.fonts.generic(60)
  self.font_text = gameWorld.assets.fonts.generic(40)
  self.fade = 0.0

  self.margin = 40
  self.print_width = 1280 - 2 * self.margin

  self.banner_y = 10
  self.score_y = 120
  self.patrons_y = 220
  self.drinks_y = 540
end

function Ending:enter()
  self.fade = 1.0
  flux.to(self, 2, { fade = 0.0 }):ease("quadinout")
  gameWorld.sound:playMusic('ending')
end

function Ending:update(dt)
  if gameWorld.playerInput:pressed('action') or gameWorld.playerInput:pressed('pour') then
    print("exit ending")
    gameWorld.gameState:setState('credits')
  end
end

function Ending:draw()
  love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
  love.graphics.setFont(self.font_banner)
  love.graphics.printf("End Message", self.margin, self.banner_y, self.print_width, 'center')

  love.graphics.setFont(self.font_heading)
  love.graphics.printf("Score:", self.margin, self.score_y, self.print_width, 'left')
  love.graphics.printf("Patrons:", self.margin, self.patrons_y, self.print_width, 'left')
  love.graphics.printf("Drinks:", self.margin, self.drinks_y, self.print_width, 'left')




  if self.fade > 0 then
    love.graphics.setColor(1.0-self.fade, 1.0-self.fade, 1.0-self.fade, self.fade) --(0.0, 0.0, 0.0, self.fade)
    love.graphics.rectangle('fill', 0, 0, 1280, 720)
  end
end

return Ending
