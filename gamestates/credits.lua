local class = require 'lib.middleclass'
local Gamestate = require 'gamestates.gamestate'

local Credits = class('Credits', Gamestate)

local function shuffle(tbl)
  for i = #tbl, 2, -1 do
    local j = math.random(i)
    tbl[i], tbl[j] = tbl[j], tbl[i]
  end
  return tbl
end


local Contributor = class('Contributor')
function Contributor:initialize(name, contact, role, font)
  self.font = font
  self.name = name
  self.contact = contact
  self.role = role
end
function Contributor:draw(x, y, h, w)
  local vsplit = h / 4
  love.graphics.setFont(self.font)
  love.graphics.printf(self.name, x, y + vsplit, w, 'center')
  love.graphics.printf(self.role, x, y + vsplit * 2, w, 'center')
  love.graphics.printf(self.contact, x, y + vsplit * 3, w, 'center')
end


function Credits:initialize(name)
  Gamestate.initialize(self, name)

  self.textfont = gameWorld.assets.fonts.generic(32)

  self.contributors = {
    Contributor:new('John Deeny', 'jdeeny@gmail.com', 'code', self.textfont),
    Contributor:new('Dieting Hippo', '@DietingHippo', 'code', self.textfont),
    Contributor:new('Drauc', 'soundcloud.com/drauc', 'audio', self.textfont),
    Contributor:new('raujinn', '@raujinn', 'art', self.textfont),
    Contributor:new('Ashe', '@', 'voice', self.textfont),
  }

  self.title = love.graphics.newText(gameWorld.assets.fonts.title(120), 'Game Title')
  self.subtitle = love.graphics.newText(self.textfont, 'Dec 25 - Dec 31 2018')

end


function Credits:enter()
  self.contributors = shuffle(self.contributors)
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
  local x = 0
  for i, contrib in ipairs(self.contributors) do
    local y = math.floor((i - 1) / 2) * ( (720 - 200 - 40) / math.floor(#self.contributors / 2 + 0.5))
    local w = (1280 - 160) / 2
    contrib:draw(x + 80, y + 200, 120, w)

    x = ((1280 - 100) / 2) - x
  end
end

return Credits
