local anim8 = require('lib.anim8')
local arch = require('entities.archetypes.archetype'):new('reindeer')

arch:addImage('main', gameWorld.assets.sprites.patrons.reindeer)
arch:addGrid('main', anim8.newGrid(199, 297, arch.images.main:getWidth(), arch.images.main:getHeight(), 0, 6, 0))

arch:addAnimation('advance', { image = arch.images.main, grid = arch.grids.main(2, 1), rate = 0.1 } )
arch:addAnimation('drink', { image = arch.images.main, grid = arch.grids.main(1, 1), rate = 0.1 } )
arch:addAnimation('hit', { image = arch.images.main, grid = arch.grids.main(3, 1), rate = 0.1 } )


arch:addTagset({ 'male', 'female', 'anygender' })
arch:addTagset({ 'reindeer', 'anykind' })
arch:setRarity(90)
arch:setSpeed(1.0)

arch:setBubbleOffset(55, -160)

arch:setSwaps( { { 0x90 / 0xFF, 0x73 / 0xFF, 0x3a / 0xFF, 1 } } )


return arch
