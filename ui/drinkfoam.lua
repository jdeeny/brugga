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

  local drink = drink or {}

  local count = math.floor(gameWorld.random:randomNormal(4, 16))
  count = (count >= 6 and count) or 6

  while count > 0 do
    local n = gameWorld.random:random(3)
    if n == 1 and drink.a then self.particles[#self.particles+1] = self:makeSuds(1,0,0) count = count - 1 end
    if n == 2 and drink.b then self.particles[#self.particles+1] = self:makeSuds(0,1,0) count = count - 1 end
    if n == 3 and drink.c then self.particles[#self.particles+1] = self:makeSuds(0,0,1) count = count - 1 end
  end

  for _, k in ipairs(self.particles) do
    k:start()
  end

end

function DrinkFoam:update(dt)
  for _, k in ipairs(self.particles) do
    k:update(dt)
  end

end
function DrinkFoam:draw()
  love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
  for _, k in ipairs(self.particles) do
    love.graphics.draw(k, self.x, self.y)
  end
end


function DrinkFoam:makeSuds(r, g, b)
  local suds = love.graphics.newParticleSystem(gameWorld.assets.sprites.ui.puff, 5)
  suds:setParticleLifetime(0.3, 0.8)
  suds:setSizeVariation(0.2)
  --suds:setEmissionArea('uniform', 1280/1.8, 0)
  suds:setDirection(PI * 2 * (gameWorld.random:random(0, 1000) / 1000))
  local spread = gameWorld.random:randomNormal(PI/32, PI/32)
  if spread < PI/128 then spread = PI/128 end
  suds:setSpread(spread)
  suds:setSpeed(55, 255)
  suds:setSizes(0.05, 0.01)
  suds:setColors(r, g, b, 0.4, r, g, b, 0.3, r, g, b, 0.0)
  --suds:setSpin(PI/4)
  --suds:setSpinVariation(PI/8)
  suds:setLinearDamping(2, 5)
  suds:setRotation(0, PI * 2)
  suds:setRadialAcceleration(-15, -30)
  suds:setRelativeRotation(false)
  suds:setEmissionRate(50)
  suds:setEmitterLifetime(0.1)
  return suds

end


return DrinkFoam
