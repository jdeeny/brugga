local class = require 'lib.middleclass'
local bump = require 'lib.bump'
local rect = require 'physics.rect'
local dude = require 'entities.dude'
local enemy = require 'entities.enemy'

function love.load()
  -- Editor's note: Most of this is test code for collisions. It can get
  -- pruned but should help with setting up entity collisions
  world = bump.newWorld(50)

  Dude = newDude()
  Dude:addToWorld(world)
  Enemy = newEnemy()
  Enemy:addToWorld(world)

  print("Subentities init'd")

  destX = 30
  destY = 160

  local actualX, actualY, cols, len = world:move(Dude.rect, destX,destY, Dude:collisionFilter())

  if len > 0 then
    print(("Attempted to move to %d,%d, but ended up in %d,%d due to %d collisions"):format(destX, destY, actualX, actualY, len))
  else
    print(("Moved A to %d,%d without collisions"):format(destX, destY))
  end

  prevX = Dude.rect.x
  prevY = Dude.rect.y
  Dude.rect.x = actualX
  Dude.rect.y = actualY

  for i,col in ipairs(cols) do
    print("foo")
    local other = col.other
    print(other)
    if other.props.isEnemy then
      print("ENEMY")
    end
  end

  Enemy:spawnEnemy("OnlyA", 2)
end

function love.keypressed(key, scancode, isrepeat)
  if (key == "w") then
    Dude:moveUp()
  end
  if (key == "s") then
    Dude:moveDown()
  end
end

function love.keyreleased(key)
  if (key == "w") then
    if (love.keyboard.isDown("s")) then
      Dude:moveDown()
    else
      Dude:moveNone()
    end
  end
  if (key == "s") then
    if (love.keyboard.isDown("w")) then
      Dude:moveDown()
    else
      Dude:moveNone()
    end
  end
end

function love.update(dt)
  Dude:update(dt)
  Enemy:update(dt)
end

function love.draw()
  love.graphics.rectangle('fill', 300, 220, 680, 40)
  love.graphics.rectangle('fill', 280, 320, 720, 40)
  love.graphics.rectangle('fill', 260, 420, 760, 40)
  love.graphics.rectangle('fill', 240, 520, 800, 40)
  love.graphics.setColor(.4, .4, .4, 100)
  love.graphics.rectangle('fill', Dude.rect.x, Dude.rect.y, Dude.rect.w, Dude.rect.h)
  love.graphics.setColor(.5, 1, .5, 100)
  love.graphics.rectangle('fill', Enemy.rect.x, Enemy.rect.y, Enemy.rect.w, Enemy.rect.h)
  love.graphics.setColor(.5, .5, 1, 100)
  love.graphics.rectangle('line', destX, destY, Dude.rect.w, Dude.rect.h)
  love.graphics.setColor(1, .2, .2, 100)
  love.graphics.rectangle('line', prevX, prevY, Dude.rect.w, Dude.rect.h)
  love.graphics.setColor(.6, .2, .1, 100)
end

function love.quit()
  print("Thanks for playing! Come back soon!")
end
