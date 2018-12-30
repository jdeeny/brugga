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
local colors = require 'ui.colors'

local Gameplay = class('Gameplay', Gamestate)
local wheelSwap = false

function Gameplay:initialize(name)
  Gamestate.initialize(self, name)

  self.rows = 3
  self.rewardTime = 0.5
  self.nextReward = self.rewardTime
end

function Gameplay:enter()
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
  self.patronZOrderCompare = function(a, b) return a.rect.x < b.rect.x end
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

  self.font = gameWorld.assets.fonts.score(50)
  self.outline = require('ui.outline'):new(self.font, 3)
  self.waveText = ("Wave %d"):format(gameWorld.playerData.wave)

  self.generator:start(gameWorld.playerData.initial_patrons, gameWorld.playerData.initial_threat)
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
  if gameWorld.playerInput:pressed('swap') or wheelSwap then
    self.brugga:swapDrinks()
    wheelSwap = false
  end

  -- Spawn drink if player presses throw
  if gameWorld.playerInput:pressed('action') then
    self.brugga:send()
  end

  -- Update entities

  if self.brugga.isActive then self.brugga:update(dt) end
  self.drinkPool:update(dt)

  -- Update patrons
  for i, p in ipairs(self.patrons) do
    p:update(dt)
    -- Cull inactive patrons
    if p.isActive == false then table.remove(self.patrons, i) end
  end
  -- Sort patron z order by x-coordinate
  table.sort(self.patrons, self.patronZOrderCompare)

  -- If all conditions are met, wave is over
  if self.generator.isActive == false and
      #self.drinkPool.active == 0 and
      #self.patrons == 0 then

    -- Increase player wave properties
    gameWorld.playerData:waveIncrease()

    -- Go to ending after 10 waves
    if gameWorld.playerData.wave > 10 then
      gameWorld.gameState:setState('ending')
    -- Start next wave
    else
      gameWorld.gameState:setState('gameplay')
    end
  end


  self.overlay:update(dt)

end

function love.wheelmoved(x, y)
  if y < 0 or y > 0 then wheelSwap = true end
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

  for i=1,self.rows do
    if self.brugga.row == i then self.brugga:draw() end

    -- Draw patrons
    love.graphics.setBackgroundColor(0,0,0,0)
    love.graphics.setColor(1,1,1,1)
    gameWorld.paletteswap:doEffect(function()

    for _, p in ipairs(self.patrons) do
      if p.row == i then p:draw() end
    end
    end)

    -- Draw drinks
    self.drinkPool:draw(i)
  end

  self.overlay:draw()
  love.graphics.draw(self.outline:getOutline(self.waveText, colors.wave, colors.wave_back), 1050, 720-90)

end

return Gameplay
