local anim8 = require('lib.anim8')
local arch = require('entities.archetypes.archetype'):new('snowman')

arch:addImage('main', gameWorld.assets.sprites.patrons.snowman)
arch:addGrid('main', anim8.newGrid(180, 317, arch.images.main:getWidth(), arch.images.main:getHeight(), 0, 45, 0))

arch:addAnimation('advance', { image = arch.images.main, grid = arch.grids.main(2, 1), rate = 0.1 } )
arch:addAnimation('drink', { image = arch.images.main, grid = arch.grids.main(1, 1), rate = 0.1 } )
arch:addAnimation('hit', { image = arch.images.main, grid = arch.grids.main(3, 1), rate = 0.1 } )

arch:addTagset({ 'male', 'anygender' })
arch:addTagset({ 'snowman', 'anykind' })
arch:setRarity(80)
arch:setSpeed(1.0)

arch:setBubbleOffset(55, -155)

arch:setSwaps( { { 0x19 / 0xFF, 0x1d / 0xFF, 0x2d / 0xFF, 1 } } )

return arch
