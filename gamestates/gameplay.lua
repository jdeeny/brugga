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
  self.BG = {
    gameWorld.assets.sprites.environment.BKG_Backlayer,
    gameWorld.assets.sprites.environment.BKG_Midlayer,
    gameWorld.assets.sprites.environment.BKG_Toplayer
  }

  -- Collision world
  self.bumpWorld = bump.newWorld(50)
  ---- Entity Creation
  -- Patrons
  self.generator = Generator:new()
  self.patrons = {}
  self.patronZOrderCompare = function(a, b) return a.rect.x < b.rect.x end
  -- Drinks
  self.drinkPool = DrinkPool:new(30, self.bumpWorld, self.overlay)
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
  self.waveEndTimer = 3
  self.waveOver = false

  self.generator:start(gameWorld.playerData.initial_patrons, gameWorld.playerData.initial_threat)

  self:checkFrenzy()
end

function  Gameplay:update(dt)
  -- Skip game updates if wave is over
  if self.waveOver then
    self.waveEndTimer = self.waveEndTimer - dt
    if self.waveEndTimer <= 0 then
      self:nextWave()
    end
    self.overlay:update(dt)
    do return end
  end

  -- Generate new patrons

  self:checkFrenzy()

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

  if gameWorld.playerInput:pressed('skipwave') then
    self:endWave()
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

    self:endWave()
  end


  self.overlay:update(dt)

end

function Gameplay:endWave()
  gameWorld.sound:playSfx('waveEnd')
  self.waveOver = true
end

function Gameplay:nextWave()
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

function love.wheelmoved(x, y)
  if y < 0 or y > 0 then wheelSwap = true end
end


function Gameplay:checkFrenzy()
  local patrons = 0 --#self.patrons
  for i, k in ipairs(self.patrons) do
    local x_factor = 0.1 + k.rect.x * k.rect.x / 250000
    local drinks = 0

    if k.drinkMix then
      local m = k.drinkMix
      drinks = drinks + (m.a and 1 or 0) + (m.b and 1 or 0) + (m.c and 1 or 0)
    end

    patrons = patrons + (1 + drinks) * x_factor
  end

  local life_factor =  (6 - gameWorld.playerData.lives) / 6


  local n = math.floor(patrons * life_factor)
  if n < 1 then n = 1 end
  if n > 6 then n = 6 end

  --print("check: ".. patrons .. " "..life_factor.. " " ..n)

  local n = #self.patrons / 3 + 1
  if n > 6 then n = 6 end
  gameWorld.sound:playStacked(n)

end

function Gameplay:draw()
  love.graphics.setColor(1.0, 1.0, 1.0, 1.0)

  -- BG
  love.graphics.draw(gameWorld.assets.sprites.environment.BKG_Baselayer)

  love.graphics.draw(gameWorld.assets.sprites.game.gem_PURPLE, 1081-10, 182-37)
  love.graphics.draw(gameWorld.assets.sprites.game.gem_GREEN, 1159-11, 356-34)
  love.graphics.draw(gameWorld.assets.sprites.game.gem_CYAN, 1235-10, 540-34)

  for i=1,self.rows do
    -- Draw Brugga
    if self.brugga.row == i then self.brugga:draw() end

    -- Draw patrons
    love.graphics.setBackgroundColor(0,0,0,0)
    love.graphics.setColor(1,1,1,1)
    --gameWorld.paletteswap:doEffect(function()
      for _, p in ipairs(self.patrons) do
        if p.row == i then p:draw() end
      end
    --end)

    -- Draw drinks
    self.drinkPool:draw(i)

    -- Draw BG layers
    love.graphics.draw(self.BG[i])
  end

  self.overlay:draw()
  love.graphics.draw(self.outline:getOutline(self.waveText, colors.wave, colors.wave_back), 1050, 720-90)

end

return Gameplay
