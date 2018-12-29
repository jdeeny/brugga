local class = require 'lib.middleclass'
local anim8 = require 'lib.anim8'
local Generator = class('Generator')

function Generator:initialize()
  self.archetypes = require('entities.archetypes'):new()
  self.threatRate = .5
  self.patronScale = 0.1
  self.scalePower = 1.1
  self.threatRateOffset = 0.3

  self.attemptsPerThreatPerSecond = 0.05

  self._threatRate = self.threatRate
  self.threat = 0
  self.patronsGenerated = 0
  self.attempsRemaining = 0.8
end

local function shuffle(tbl)
  for i = #tbl, 2, -1 do
    local j = math.random(i)
    tbl[i], tbl[j] = tbl[j], tbl[i]
  end
  return tbl
end

function Generator:generate()
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
  if love.math.random(50) < self.threat then drink_complexity = drink_complexity + 1 end
  if love.math.random(100) < self.threat then drink_complexity = drink_complexity + 1 end

  local ingredients = { 'a', 'b', 'c' }
  ingredients = shuffle(ingredients)
  local drink = {}
  for i=1, drink_complexity do
    drink[#drink+1] = ingredients[i]
  end

  --pretty.dump(drink)

  local speed = 1 + math.random(self.threat) / 100

  print(speed)

  local threat = speed * drink_complexity

  self.threat = self.threat - threat

  print("Threat: " .. threat .. " " .. self.threat)

  return { animations = animations, images=images, drink=drink, speed=speed, row=math.random(3), threat = threat }
end

function Generator:update(dt)
  self._threatRate = self.threatRate * math.pow(self.patronsGenerated * self.patronScale, self.scalePower) + self.threatRateOffset
  self.threat = self.threat + self._threatRate * dt
  self.attempsRemaining = self.attempsRemaining + self.attemptsPerThreatPerSecond * self.threat * dt

  --print("Threat: " .. self._threatRate .. " " .. self.threat)
  --print("Patrons: " .. self.patronsGenerated .. " " .. self.attempsRemaining)

end

-- Return a patron type or nil
function Generator:nextPatron()
  return nil
end

return Generator
