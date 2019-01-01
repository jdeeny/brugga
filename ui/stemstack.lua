local class = require 'lib.middleclass'

local StemStack = class('StemStack')

function StemStack:initialize(sources)
  self.buffers = 16
  self.loops = sources or {}
  self.sources = {}
  for i, k in ipairs(self.loops) do
    self.sources[i] = {}
    repeat
      local src = self.loops[i]:decode()
      if src then
        self.sources[i][#self.sources[i]+1] = src
      end
    until not src
  end
  self.queue = love.audio.newQueueableSource(44100, 16, 2, self.buffers)
  self.playing = false
  self.next = false
  self.loc = 0
end

function StemStack:stop()
  self.playing = false
  self.target = false
end

function StemStack:play()
  self.target = 1
end


function StemStack:setLevel(level)
  local level = math.floor(level)
  if self.playing == level then return end
  if level >= 1 and level <= 10 then
    self.target = level
  else
--    self.target = nil
    --self.playing = self.target
    --self.queue:stop()
  end
end

function StemStack:update(dt)
  if not self.playing then self.playing = self.target end

  if not self.playing then self.queue:stop() end

  if self.queue then self.queue:setVolume(gameWorld.settings.config.music_volume or 0.5) end
  
  if self.playing and not self.queue:isPlaying() then
    --print("new q")
    self.queue = self:newQueue()
    self.loc = 1
    self:loadstem(level)
    self.queue:play()
  end


  if self.playing or self.target then
    self:loadstem()
    self.queue:play()
  end

end

function StemStack:loadstem()
  --print("load" .. self.queue:getFreeBufferCount() .. " " .. self.playing)

  while self.loops[self.playing] and self.queue:getFreeBufferCount() > 0 do
    self.loc = self.loc + 1
    --print("loc" .. self.loc)
    if not self.sources[self.playing][self.loc] then
      self.loc = 1
      if self.target ~= self.playing then
        self.playing = self.target
      end
    end
    --print("loc " .. self.loc .." self.playing " .. self.playing)
    --pretty.dump(self.loops[level])
    if self.playing and self.sources[self.playing] and self.sources[self.playing][self.loc] then
      self.queue:queue(self.sources[self.playing][self.loc])
    end
  end
end


function StemStack:newQueue()
  return love.audio.newQueueableSource(44100, 16, 2, self.buffers)

end

return StemStack
