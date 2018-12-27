local class = require 'lib.middleclass'
local bump = require 'lib.bump'
local rect = require 'physics.rect'
local dude = require 'entities.dude'
local enemy = require 'entities.enemy'
local baton = require 'lib.baton'

local world = {}
local gamestates = {}
local playerInput = {}

function love.load()
  playerInput = baton.new { controls = { ok = { 'key:enter' } }, }
  gamestates = require('gamestates.manager'):new(playerInput)
end


--[[
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
]]
function love.update(dt)
  playerInput:update()  -- update the input immediately so everything else can use the up to date info
  gamestates:update(dt)
end

function love.draw()
  gamestates:draw()

  love.graphics.rectangle('fill', 300, 220, 680, 40)
end

function love.quit()
  print("Thanks for playing! Come back soon!")
end
