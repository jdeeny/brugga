local class = require 'lib.middleclass'

local StemStack = class('StemStack')

function StemStack:initialize(sources)
  self.buffers = 8
  self.loops = sources or {}
  self.sources = {}
  for i, k in ipairs(self.loops) do
    self.sources[i] = {}
    repeat
      local src = self.loops[i]:decode()
      if src then
        self.sources[i][#self.sources[i]+1] = src
        print('src')
      end
    until not src
  end
  self.queue = love.audio.newQueueableSource(44100, 16, 2, self.buffers)
  self.playing = false
  self.next = false
  self.loc = 0
end

function StemStack:setLevel(level)
  if self.playing == level then return end
  self.playing = level or false
  if self.playing and not self.queue:isPlaying() then
    self.queue = self:newQueue()
    self:loadstem(level)
    self.queue:play()
  end
  if not self.playing then self.queue:stop() end
end

function StemStack:update(dt)
  if self.playing then
    self:loadstem(self.playing)
    self.queue:play()
  end
end

function StemStack:loadstem(level)
  while self.loops[level] and self.queue:getFreeBufferCount() > 0 do
    self.loc = self.loc + 1
    if not self.sources[level][self.loc] then
      self.loc = 1
    end
    print("loc " .. self.loc .." level " .. self.playing)
    --pretty.dump(self.loops[level])
    self.queue:queue(self.sources[level][self.loc])
  end
end

function StemStack:newQueue()
  return love.audio.newQueueableSource(44100, 16, 2, self.buffers)

end

return StemStack
