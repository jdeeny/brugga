local cargo = require 'lib.cargo'
local class = require 'lib.middleclass'
local bump = require 'lib.bump'
local Dude = require 'entities.dude'
local Enemy = require 'entities.enemy'
local Drink = require 'entities.drink'
local DrinkPool = require 'entities.drinkpool'
local Generator = require 'entities.generator'
local Zone = require 'entities.zone'
local Gamestate = require 'gamestates.gamestate'

local Gameplay = class('Gameplay', Gamestate)

function Gameplay:initialize(name)
  Gamestate.initialize(self, name)

  self.rows = 3
  self.rewardTime = 0.5
  self.nextReward = self.rewardTime
end

function Gameplay:enter()
  -- reset score
  gameWorld.playerData:reset()


  self.overlay = require('ui.overlay'):new()

  -- Graphics
  self.assets = cargo.init('assets')
  self.BG = self.assets.sprites.environment.Background

  -- Collision world
  self.bumpWorld = bump.newWorld(50)
  ---- Entity Creation
  -- Patrons
  self.generator = Generator:new()
  self.patrons = {}
  -- Drinks
  self.drinkPool = DrinkPool:new(30, self.bumpWorld)
  -- Brugga
  self.brugga = Dude:new()
  self.brugga:addToWorld(self.bumpWorld)
  self.brugga:spawn(self.drinkPool)

  -- Zones
  self.startZones = {}
  self.endZones = {}
  for i=1,self.rows do
    table.insert(self.startZones, Zone:new(i, "start", self.bumpWorld))
    table.insert(self.endZones, Zone:new(i, "end", self.bumpWorld))
  end

  self.generator:start(12, 10)
end

function  Gameplay:update(dt)
  -- Generate new patrons
  self.generator:update(dt)
  local gen = self.generator:generate()
  if gen then
    --pretty.dump(gen)
    local new_patron = Enemy:new(gen, self.overlay)      -- Create new patron
    new_patron:addToWorld(self.bumpWorld)       -- Add to bump world
    table.insert(self.patrons, new_patron) -- Put in master patron table
  end

  if gameWorld.playerInput:pressed('pause') then
    gameWorld.gameState:pushState('pause')
  elseif gameWorld.playerInput:pressed 'jumptoend' then  -- TODO: Quit on death or through menu only
    print("exit gameplay")
    gameWorld.gameState:setState('ending')
  end

  if gameWorld.playerInput:released('up') or gameWorld.playerInput:released('down') then
    self.brugga:moveNone()
  elseif gameWorld.playerInput:pressed('up') then
    self.brugga:moveUp()
  elseif gameWorld.playerInput:pressed('down') then
    self.brugga:moveDown()
  end

  -- Pour drink
  if gameWorld.playerInput:pressed('pour') then
    self.brugga:pour()
  end

  -- Swap drink
  if gameWorld.playerInput:pressed('swap') then
    self.brugga:swapDrinks()
  end

  -- Spawn drink if player presses throw
  if gameWorld.playerInput:pressed('action') then
    self.brugga:send()
  end

  -- Update entities

  if self.brugga.isActive then self.brugga:update(dt) end
  self.drinkPool:update(dt)

  -- Update patrons
  for _, p in ipairs(self.patrons) do
    p:update(dt)
  end

  self.overlay:update(dt)
end

function Gameplay:draw()
  love.graphics.setColor(1.0, 1.0, 1.0, 1.0)

  -- BG
  love.graphics.draw(self.BG)

  ---- DEBUG DRAW -- --
  love.graphics.setColor(1.0, 0.0, 0.0, 1.0)
  love.graphics.rectangle('fill', 1000, 150, 100, 100)
  love.graphics.setColor(0.0, 1.0, 0.0, 1.0)
  love.graphics.rectangle('fill', 1040, 335, 100, 100)
  love.graphics.setColor(0.0, 0.0, 1.0, 1.0)
  love.graphics.rectangle('fill', 1080, 520, 100, 100)

  --[[]
  -- Zones
  for i=1,self.rows do
    self.startZones[i]:draw()
    self.endZones[i]:draw()
  end

  -- Debug bar boxes
  love.graphics.setColor(.6, .2, .1, 100)
  love.graphics.rectangle('fill', 150, 200, 670, 40)
  love.graphics.rectangle('fill', 75, 385, 785, 40)
  love.graphics.rectangle('fill', 0, 570, 900, 40)
  --]]

  self.brugga:draw() -- Draw brugga

  -- Draw patrons
  for _, p in ipairs(self.patrons) do
    p:draw()
  end

  -- Draw drinks
  for i=1,self.rows do
    self.drinkPool:draw(i)
  end

  self.overlay:draw()

end

return Gameplay
