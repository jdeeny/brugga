local class = require 'lib.middleclass'

local Archetypes = class('Archetypes')

function Archetypes:initialize()
  self.kinds = {
    require('entities.archetypes.elf_swole'),
    require('entities.archetypes.elf_test'),
    require('entities.archetypes.elf_female'),
  }

  self.rarity_total = 0.0
  for _, arch in ipairs(self.kinds) do
    self.rarity_total = self.rarity_total + arch.rarity
  end

end

function Archetypes:getRandom()
  local pick = love.math.random(self.rarity_total)
  for i, arch in ipairs(self.kinds) do
    pick = pick - arch.rarity
    if pick <= 0.0 then return arch end
  end
  print("Pick didn't find something!?")
  return nil
end

return Archetypes
