local class = require 'lib.middleclass'

local PI = 3.14159

local DrinkFoam = class('DrinkFoam')

function DrinkFoam:initialize()
  self.x = 0
  self.y = 0
  self.drink = {}
  self.particles = {}
end

function DrinkFoam:createFoam(x, y, drink)
  self.x = x
  self.y = y
  local suds = love.graphics.newParticleSystem(gameWorld.assets.sprites.snow.simple, 20)
  suds:setParticleLifetime(0.3, 0.9)
  suds:setSizeVariation(1)
  --suds:setEmissionArea('uniform', 1280/1.8, 0)
  suds:setLinearAcceleration(10, 5, 10, 5)
  --suds:setDirection(DOWN)
  suds:setSpread(PI * 2)
  suds:setSpeed(30, 55)
  suds:setSizes(0.1)
  suds:setColors(.95, 0.95, 1.0, 0.7)
  --suds:setSpin(PI/4)
  --suds:setSpinVariation(PI/8)
  suds:setRotation(0, PI * 2)
  suds:setRadialAcceleration(0, 0.2)
  suds:setRelativeRotation(false)
  suds:setTangentialAcceleration(0.25, 0.5)
  suds:setEmissionRate(100)
  suds:setEmitterLifetime(0.05)
  self.particles['suds'] = suds

  for _, k in pairs(self.particles) do
    k:start()
    print("started")
  end

end

function DrinkFoam:update(dt)
  for _, k in pairs(self.particles) do
    k:update(dt)
  end
end
function DrinkFoam:draw()
  love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
  for _, k in pairs(self.particles) do
    love.graphics.draw(k, self.x, self.y)
  end
end
return DrinkFoam
