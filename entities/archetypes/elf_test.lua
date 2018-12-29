local arch = require('entities.archetypes.archetype'):new('elf_test')

arch:addImage(gameWorld.assets.sprites.patrons.test, 'main')
arch:addGrid(anim8.newGrid(32, 32, self.images.main:getWidth(), self.images.main:getHeight(), 0, 0, 0), 'main')

arch:addAnimation(anim8.newAnimation(self.grids.main('1-3', 1, 0.1), 'sitting'))
arch:addAnimation(anim8.newAnimation(self.grids.main('1-3', 1, 0.1), 'drinking'))
arch:addAnimation(anim8.newAnimation(self.grids.main('1-3', 1, 0.1), 'holding'))

arch:addTagset({ 'male', 'female', 'anygender' })
arch:addTagset({ 'elf', 'anykind', })
arch:setRarity(1.0)
arch:setSpeed(1.0)

return arch
