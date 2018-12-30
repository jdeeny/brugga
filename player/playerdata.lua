local class = require 'lib.middleclass'

local PlayerData = class('PlayerData')

function PlayerData:initialize()
  self:reset()
end

function PlayerData:reset()
  self.score = 0
  self.patron_history = {}
  self.drink_history = {}
end




function PlayerData:scoreIncrease(i)
  gameWorld.sound:playSfx('coin')
  self.score = self.score + i
end

function PlayerData:recordPatron(patron)
  self.patron_history[#self.patron_history + 1] = patron
end

function PlayerData:recordDrink(drink)
  self.drink_history[#self.drink_history + 1] = drink
end

return PlayerData
