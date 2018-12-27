local class = require 'lib.middleclass'
local pl = require 'lib.pl'

local splash = require 'gamestates.splash'
local title = require 'gamestates.title'
local gameplay = require 'gamestates.gameplay'
local ending = require 'gamestates.ending'
local credits = require 'gamestates.credits'
local pause = require 'gamestates.pause'

local GamestateManager = class('GamestateManager')

function GamestateManager:initialize(input)
  self.states = {
    ["splash"] = splash,
    ["title"] = title,
    ["gameplay"] = gameplay,
    ["ending"] = ending,
    ["credits"] = credits,
    ["pause"] = pause,
  }
  self.input = input

  self:setState('splash')

end

-- Sets the state, dropping any in the stack
function GamestateManager:setState(state)
  self.current = { state, }
  if state.enter then st:enter() end
  if state.controls then self.input.controls = pl.tablex.copy(self.controls) end
end

-- Enter a state by pushing it on the stack
function GamestateManager:pushState(state)
  self.current[#(self.current)] = state
end

-- Leave a state by popping from the stack
function GamestateManager:exitState()
  local st = self:getState()
  if st.exit then st:exit() end
  if #self.current > 1 then
    table.remove(self.current, #self.current)
  end

  st = self:getState()
  if st.returnTo then st:returnTo() end
end

function GamestateManager:getCurrent()
  return self.current[#self.current]
end

function GamestateManager:getState()
  return self.states[self:getCurrent()]
end

function GamestateManager:update(dt)
  local st = self:getState()
  if st.update then st:update() end
end

function GamestateManager:draw()
  local st = self:getState()
  if st.draw then st:draw() end
end

return GamestateManager
