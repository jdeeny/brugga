local class = require 'lib.middleclass'
local cargo = require 'lib.cargo'
local ripple = require 'lib.ripple'

local SoundManager = class('SoundManager')

function SoundManager:initialize()
  self.music = {}
  self.tags = {
    music = ripple.newTag(),
    sfx = ripple.newTag(),
    drink = ripple.newTag(),
    angry = ripple.newTag(),
    male = ripple.newTag(),
  }
  --for m in gameWorld.assets.music do
  --  self.music[m] = ripple.newSound({source = m, volume = gameWorld.options.musicVolume, tags = { 'music' }})
  --end
  print(gameWorld.assets.music.sonata)
  self.music['test'] = ripple.newSound({source = gameWorld.assets.music.sonata, tags = { self.tags.music, self.tags.sound }})
  for _, t in ipairs(self:scanTags('music/drink_male.ogg')) do
    print(t)
  end
  self.music['test']:setLooping(true)

  self.musicPlaying = false
end

function SoundManager:scanTags(path)
  local tags = {}
  for tag, _ in pairs(self.tags) do
    if string.find(path, tag) then
      table.insert(tags, tag)
    end
  end
  return tags
end


function SoundManager:playMusic()
  self.musicPlaying = 'test'
  self.music[self.musicPlaying]:play()

end

function SoundManager:setMusicVolume(vol)
  self.tags.music.volume = vol
end

function SoundManager:setSfxVolume()
  self.tags.sfx.volume = vol
end

function SoundManager:mute()
  self.tags.sound.volume = 0.0
end

function SoundManager:stopMusic()
  if self.musicPlaying and self.music[self.musicPlaying] then
    self.music[self.musicPlaying]:stop()
    self.musicPlaying = false
  end
end

function SoundManager:isMusicPlaying()
  return self.musicPlaying
end

return SoundManager