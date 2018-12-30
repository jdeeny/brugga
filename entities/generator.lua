local class = require 'lib.middleclass'
local anim8 = require 'lib.anim8'
local Generator = class('Generator')

function Generator:initialize()
  self.isActive = false
  self.archetypes = require('entities.archetypes'):new()
  self.threatRate = .5
  self.patronScale = 0.1
  self.scalePower = 1.1
  self.threatRateOffset = 0.3

  self.attemptsPerThreatPerSecond = 0.05

  self._threatRate = self.threatRate
  self.threat = 0
  self.patronsGenerated = 0
  self.maxPatrons = 0
  self.attempsRemaining = 0.8
end

local function shuffle(tbl)
  for i = #tbl, 2, -1 do
    local j = math.random(i)
    tbl[i], tbl[j] = tbl[j], tbl[i]
  end
  return tbl
end

function Generator:start(maxPatrons, startingThreat)
  self.isActive = true
  self.maxPatrons = maxPatrons
  self.threat = startingThreat
end

function Generator:stop()
  self.isActive = false
end

function Generator:generate()
  if self.isActive == false then return nil end

  if self.attempsRemaining < 1.0 then return nil end

  self.attempsRemaining = self.attempsRemaining - 1
  self.patronsGenerated = self.patronsGenerated + 1

  local archetype = self.archetypes:getRandom()
  local animations = {}
  local images = {}

  for name, anim in pairs(archetype.animations) do
    print("archs: "..name)
    animations[name] = anim8.newAnimation(anim.grid, anim.rate)
    images[name] = anim.image
  end

  print("endarchs")
  local drink_complexity = 1
  if gameWorld.random:random(50) < self.threat then drink_complexity = drink_complexity + 1 end
  if gameWorld.random:random(100) < self.threat then drink_complexity = drink_complexity + 1 end

  local ingredients = { 'a', 'b', 'c' }
  ingredients = shuffle(ingredients)
  local drink = {}
  for i=1, drink_complexity do
    drink[ingredients[i]] = true
  end

  local speed = 1 + math.random(self.threat) / 100

  print(speed)

  local threat = speed * drink_complexity

  self.threat = self.threat - threat

  print("Threat: " .. threat .. " " .. self.threat)

  return { animations = animations, images=images, drink=drink, speed=speed, row=gameWorld.random:random(3), threat = threat }
end

function Generator:update(dt)
  -- Don't update if inactive
  if self.isActive == false then
    do return end
  end

  -- If max patrons reached, stop generating
  if self.patronsGenerated >= self.maxPatrons then
    self:stop()
  -- Else, update threat rate,
  else
    self._threatRate = self.threatRate * math.pow(self.patronsGenerated * self.patronScale, self.scalePower) + self.threatRateOffset
    self.threat = self.threat + self._threatRate * dt
    self.attempsRemaining = self.attempsRemaining + self.attemptsPerThreatPerSecond * self.threat * dt

    -- Capping out threat at 33
    if self.threat > 33 then self.threat = 33 end
    --print("Threat: " .. self._threatRate .. " " .. self.threat)
    --print("Patrons: " .. self.patronsGenerated .. " " .. self.attempsRemaining)
  end
end

-- Return a patron type or nil
function Generator:nextPatron()
  return nil
end

return Generator
