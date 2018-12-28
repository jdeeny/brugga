local class = require 'lib.middleclass'

local Generator = class('Generator')

function Generator:initialize()
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

function Generator:generate()
  if self.attempsRemaining < 1.0 then return nil end

  self.attempsRemaining = self.attempsRemaining - 1
  self.patronsGenerated = self.patronsGenerated + 1

  return { tags={ 'elf', 'female', 'angry' }, appearance=reference_to_sprite_stuff_tbd, drink={'a', 'c'}, speed=1 }
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
