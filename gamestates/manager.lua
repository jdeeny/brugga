local class = require 'lib.middleclass'


local splash = require 'gamestates.splash'
local title = require 'gamestates.title'
local gameplay = require 'gamestates.gameplay'
local ending = require 'gamestates.ending'
local credits = require 'gamestates.credits'
local pause = require 'gamestates.pause'

local GamestateManager = class('GamestateManager')

function GamestateManager:initialize()
  self.states = {
    splash = splash:new('splash'),
    title = title:new('title'),
    gameplay = gameplay:new('gameplay'),
    ending = ending:new('ending'),
    credits = credits:new('credits'),
    pause = pause:new('pause'),
  }
  pretty.dump(self.states)
  self.current = { }
  self:setState('splash')
end

-- Sets the state, dropping any in the stack
function GamestateManager:setState(state)
  self.current = { }
  self:pushState(state)
end

-- Enter a state by pushing it on the stack
function GamestateManager:pushState(state)
  self.current[#self.current + 1] = state
  local st = self:getState()
  st:enter()
end

-- Leave a state by popping from the stack
function GamestateManager:exitState()
  local st = self:getState()
  st:exit()
  self.current[#self.current] = nil

  st = self:getState()
  returnTo()
end

function GamestateManager:getCurrent()
  return self.current[#self.current]
end

function GamestateManager:getState()
  print("current = " .. self:getCurrent())
  pretty.dump(self.states)
  return self.states[self:getCurrent()]
end

function GamestateManager:update(dt)
  print(self:getCurrent())
  print(self:getState())
  local st = self:getState()
  if st.update then st:update() end
end

function GamestateManager:draw()
  local st = self:getState()
  if st.draw then st:draw() end
end

return GamestateManager
