local class = require 'lib.middleclass'
local cargo = require 'lib.cargo'
local ripple = require 'lib.ripple'

local SoundManager = class('SoundManager')

function SoundManager:initialize()
  self.music = {}
  self.ui = {}
  self.sfx = {}


  -- Some tags are used to control volume (music)
  -- Some tags are used to categorize sounds (male)
  self.tags = {
    ui = ripple.newTag(),
    music = ripple.newTag(),
    sfx = ripple.newTag(),
    drink = ripple.newTag(),
    angry = ripple.newTag(),
    male = ripple.newTag(),
  }

  --[[assets = cargo.init({
    dir = 'my_assets',
    loaders = {
      jpg = love.graphics.newImage
    },
    processors = {
      ['images/'] = function(image, filename)
        image:setFilter('nearest', 'nearest')
      end
    }
  })]]


  self.ui.assets = cargo.init('assets')

--  for name, sound in pairs(gameWorld.assets.audio.ui) do
--    self.ui[name] = ripple.newSound({source = sound, tags = { self.tags.sfx }})
--  end
  self.ui['menuSelect'] = ripple.newSound({source = gameWorld.assets.audio.ui.menuSelect, tags = { self.tags.sfx, self.tags.ui, }})
  self.ui['menuSwitch'] = ripple.newSound({source = gameWorld.assets.audio.ui.menuSwitch, tags = { self.tags.sfx, self.tags.ui, }})
  self.ui['gameOver'] = ripple.newSound({source = gameWorld.assets.audio.ui.gameOver, tags = { self.tags.sfx, self.tags.ui, }})
  self.ui['volumeIncrease'] = ripple.newSound({source = gameWorld.assets.audio.ui.volumeIncrease, tags = { self.tags.sfx, self.tags.ui, }})
  self.ui['volumeDecrease'] = ripple.newSound({source = gameWorld.assets.audio.ui.volumeDecrease, tags = { self.tags.sfx, self.tags.ui, }})
  self.ui['musicIncrease'] = ripple.newSound({source = gameWorld.assets.audio.ui.volumeIncrease, tags = { self.tags.music, self.tags.ui, }})
  self.ui['musicDecrease'] = ripple.newSound({source = gameWorld.assets.audio.ui.volumeDecrease, tags = { self.tags.music, self.tags.ui, }})

  --for m in gameWorld.assets.music do
  --  self.music[m] = ripple.newSound({source = m, volume = gameWorld.options.musicVolume, tags = { 'music' }})
  --end
  self.music['test'] = ripple.newSound({source = gameWorld.assets.audio.music.wintersTouch, tags = { self.tags.music, }})
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

function SoundManager:playUi(name)
  print("PlayUI: " .. name)
  pretty.dump(self.ui)
  if self.ui[name] then self.ui[name]:play() end
end


function SoundManager:playMusic()
  self.tags.music:stop()
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
