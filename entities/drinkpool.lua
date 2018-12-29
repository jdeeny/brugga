local class = require 'lib.middleclass'
local Drink = require 'entities.drink'

local DrinkPool = class('DrinkPool')

function DrinkPool:initialize(drinkAmt, bumpWorld)
  self.bumpWorld = bumpWorld

  -- Generate drinks
  self.drinks = {}
  for i=1,drinkAmt do
    table.insert(self.drinks, Drink:new())
  end

  self.active = {}  -- No drinks initially active
  self.inactive = {table.unpack(self.drinks)} -- Copy inactive drinks to inactive table
end

function DrinkPool:getNewDrink()
  local newDrink

  if table.getn(self.inactive) == 0 then
    newDrink = nil  -- Return nil if no inactive drinks found
  else
    newDrink = self.inactive[1]           -- Get first inactive drink
    newDrink.isActive = true              -- Set active
    newDrink.props.drinkMix = {}
    newDrink.props.state = "held"
    newDrink:addToWorld(self.bumpWorld)
    table.insert(self.active, newDrink)      -- Add to active table
    table.remove(self.inactive, 1) -- Remove from inactive table
  end

  return newDrink
end

function DrinkPool:update(dt)
  for i,drink in ipairs(self.active) do
    -- Cull if now inactive
    if drink.isActive == false then
      table.insert(self.inactive, drink)  -- Add to inactive table
      table.remove(self.active, i) -- Remove from active table
    else
      drink:update(dt)
    end
  end
end

function DrinkPool:draw(row)
  for _,drink in ipairs(self.active) do
    if drink.row == row then
      drink:draw()
    end
  end
end

return DrinkPool
