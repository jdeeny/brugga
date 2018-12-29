local arch = require('entities.archetypes.archetype'):new('elf_female')

arch:addImage(gameWorld.assets.sprites.patrons.elf_female, 'main')
arch:addGrid(anim8.newGrid(210, 234, self.images.main:getWidth(), self.images.main:getHeight(), 0, 0, 0), 'main')
arch:addAnimation(anim8.newAnimation(self.grids.main(2, 1, 0.1), 'sitting'))
arch:addAnimation(anim8.newAnimation(self.grids.main(1, 1, 0.1), 'drinking'))
arch:addAnimation(anim8.newAnimation(self.grids.main(3, 1, 0.1), 'holding'))

arch:addTagset({ 'female', 'anygender' })
arch:addTagset({ 'elf', 'anykind' })
arch:setRarity(1.0)
arch:setSpeed(1.0)

return arch
