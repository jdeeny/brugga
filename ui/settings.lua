local bitser = require 'lib.bitser'
local class = require 'lib.middleclass'

local Settings = class('Settings')

function Settings:initialize()
  self.filename = 'config'
  self.config = {}
  self:defaults()
end

function Settings:defaults()
  self.config.sfx_volume = 0.7
  self.config.music_volume = 0.6
  self.config.high_score = 0.0
  self.config.endless_high_score = 0.0
end

function Settings:load()
  if love.filesystem.getInfo(self.filename) then
    local conf = bitser.loadLoveFile(self.filename)
    if conf.sfx_volume then self.config.sfx_volume = conf.sfx_volume end
    if conf.music_volume then self.config.music_volume = conf.music_volume end
    if conf.high_score then self.config.high_score = conf.high_score end
    if conf.endless_high_score then self.config.endless_high_score = conf.endless_high_score end
  else
    return false
  end
end

function Settings:save()
  bitser.dumpLoveFile(self.filename, self.config)
end

return Settings
