local class = require 'lib.middleclass'
local bump = require 'lib.bump'
local rect = require 'physics.rect'
local cargo = require 'lib.cargo'
local baton = require 'lib.baton'
require 'lib.pl'    -- provides on-demand lading on the penlight sublibraries

-- Should be the only global
gameWorld = {}

function love.load()
  gameWorld.settings = require('ui.settings'):new()
  gameWorld.settings:load()
  gameWorld.settings:save()

  gameWorld.assets = cargo.init('assets')
  gameWorld.colors = require('ui.colors')
  gameWorld.sound = require('ui.sound'):new()

  -- Comment this out to disable debug print
  gameWorld.debug = require('ui.debug'):new()

  gameWorld.playerInput = baton.new {
    controls = {
      left = {'key:left', 'key:a', 'axis:leftx-', 'button:dpleft'},
      right = {'key:right', 'key:d', 'axis:leftx+', 'button:dpright'},
      up = {'key:up', 'key:w', 'axis:lefty-', 'button:dpup'},
      down = {'key:down', 'key:s', 'axis:lefty+', 'button:dpdown'},
      ok = { 'key:return' },
      throw = { 'key:space' },
      pause = { 'key:p' },
    },
    pairs = {
      move = { 'left', 'right', 'up', 'down' },
    },
    joystick = love.joystick.getJoysticks()[1],
  }

  gameWorld.gameState = require('gamestates.manager'):new()
  gameWorld.playerScore = 0
end

function love.update(dt)
  gameWorld.playerInput:update()  -- update the input immediately so everything else can use the up to date info
  gameWorld.gameState:update(dt)
  if gameWorld.debug then gameWorld.debug:update(dt) end
end

function love.draw()
  gameWorld.gameState:draw()
  if gameWorld.debug then gameWorld.debug:draw() end
end

function love.quit()
  print("Thanks for playing! Come back soon!")
end


-- switch to a newly connected joystick
function love.joystickadded(j)
  if gameWorld.playerInput then gameWorld.playerInput.joystick = j end
end
