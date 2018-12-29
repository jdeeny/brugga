local class = require 'lib.middleclass'
local Gamestate = require 'gamestates.gamestate'

local Credits = class('Credits', Gamestate)

function Credits:initialize(name)
  Gamestate.initialize(self, name)

  self.textfont = gameWorld.assets.fonts.generic(30)

  self.contributors = {
    { name="John Deeny", contact="jdeeny@gmail.com", role="code", },
    { name="Dieting Hippo", contact="@", role="code",},
    { name="Drauc", contact="soundcloud.com/drauc", role="audio", },
    { name="raujinn", contact="@raujinn", role="art", },
    { name="Ashe", contact="@", role="voice", },
    -- { name="Xibanya", contact="@", role="voice", },
    -- { name="Mihai", contact="@", role="voice", },
  }

  self.title = love.graphics.newText(gameWorld.assets.fonts.title(120), 'Game Title')
  self.subtitle = love.graphics.newText(self.textfont, 'Dec 25 - Dec 31 2018')

  -- Create text for each contributor
  for i, contrib in ipairs(self.contributors) do
    contrib.nameText = love.graphics.newText(self.textfont, contrib.name)
    contrib.contactText = love.graphics.newText(self.textfont, contrib.contact)
    contrib.roleText = love.graphics.newText(gameWorld.assets.fonts.generic(30), contrib.role)
  end



end


function Credits:enter()
  gameWorld.sound:playMusic('credits')
end

function Credits:exit()
end

function Credits:update(dt)
  if gameWorld.playerInput:pressed('action') then gameWorld.gameState:setState('title') end
end

function Credits:draw()
  love.graphics.clear(1.0, 1.0, 1.0, 1.0)
  love.graphics.setColor(gameWorld.colors.lightblue)
  love.graphics.draw(self.title, 1280 / 2 - self.title:getWidth() / 2, 50)
  for i, contrib in ipairs(self.contributors) do
    love.graphics.draw(contrib.nameText, 100, i * 100)
    love.graphics.draw(contrib.roleText, 100, i * 100 + 30)
    love.graphics.draw(contrib.contactText, 100, i * 100 + 60)
  end
end

return Credits
