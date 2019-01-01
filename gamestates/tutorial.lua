local class = require 'lib.middleclass'
local Gamestate = require 'gamestates.gamestate'

local Tutorial = class('Tutorial', Gamestate)

function Tutorial:initialize(name)
  Gamestate.initialize(self, name)
  self.fade = 0.0

  self.titlefont = gameWorld.assets.fonts.title(48)
  self.textfont = gameWorld.assets.fonts.generic(32)
end


function Tutorial:enter()
  self.fade = 1.0
  flux.to(self, 1, { fade = 0.0 }):ease("quadinout")

  self.backsnow = require('ui.snow'):new()
  self.snow = require('ui.snow'):new()
  gameWorld.sound:playMusic('credits')

  self.page = 1 -- Set current tutorial page

  -- Image init
  self.images = gameWorld.assets.sprites.tutorial
  self.pourImages = {
    self.images.pourSet1,
    self.images.pourSet2,
    self.images.pourSet3
  }
  self.sendImages = {
    self.images.sendSet1,
    self.images.sendSet2,
    self.images.sendSet3
  }
  self.swapImages = {
    self.images.swapSet1,
    self.images.swapSet2,
    self.images.swapSet3,
    self.images.swapSet4
  }
  self.moveImages = {
    self.images.moveSet1,
    self.images.moveSet2,
    self.images.moveSet3,
    self.images.moveSet2
  }
  self.mouseImages = {
    left = self.images.mouseLeft,
    right = self.images.mouseRight,
    middle = self.images.mouseMiddle,
    none = self.images.mouseNone
  }
  self.keyImages = {
    up = self.images.keyUp,
    down = self.images.keyDown,
    left = self.images.keyLeft,
    right = self.images.keyRight,
    none = self.images.keyNone
  }

  self.pour_image = {
    image = self.pourImages,
    x = 40, y = 75,
    frame = 1, frames = 3, duration = 1, timer = 1 }
  self.send_image = {
    image = self.sendImages,
    x = 840, y = 100,
    frame = 1, frames = 3, duration = 1, timer = 1 }
  self.swap_image = {
    image = self.swapImages,
    x = 65, y = 100,
    frame = 1, frames = 4, duration = 1, timer = 1 }
  self.move_image = {
    image = self.moveImages,
    x = 840, y = 100,
    frame = 1, frames = 4, duration = 1, timer = 1 }
  self.mouse_image = {
    pour = {
      image = {
        self.mouseImages.none,
        self.mouseImages.right,
        self.mouseImages.none,
      },
      x = 180, y = 500,
      frame = 1, frames = 3, duration = 1, timer = 1
    },
    send = {
      image = {
        self.mouseImages.none,
        self.mouseImages.left,
        self.mouseImages.none,
      },
      x = 950, y = 500,
      frame = 1, frames = 3, duration = 1, timer = 1
    },
    swap = {
      image = {
        self.mouseImages.none,
        self.mouseImages.none,
        self.mouseImages.middle,
        self.mouseImages.none,
      },
      x = 180, y = 500,
      frame = 1, frames = 4, duration = .5, timer = .5
    }
  }
  self.key_image = {
    move = {
      image = {
        self.keyImages.up,
        self.keyImages.none,
        self.keyImages.down,
        self.keyImages.none,
        self.keyImages.down,
        self.keyImages.none,
        self.keyImages.up,
        self.keyImages.none,
      },
      x = 900, y = 550,
      frame = 1, frames = 8, duration = .5, timer = .5
    }
  }
end

function Tutorial:exit()
end

function Tutorial:update(dt)
  self.backsnow:update(dt*0.9)
  self.snow:update(dt)


  ---- Update timers
  if self.page == 1 then
    self:updateImage(self.pour_image, dt)
    self:updateImage(self.mouse_image.pour, dt)
    self:updateImage(self.send_image, dt)
    self:updateImage(self.mouse_image.send, dt)
    if gameWorld.playerInput:pressed('action') or gameWorld.playerInput:pressed('pause') then
      self.page = 2
    end
  elseif self.page == 2 then
    self:updateImage(self.swap_image, dt)
    self:updateImage(self.mouse_image.swap, dt)
    self:updateImage(self.move_image, dt)
    self:updateImage(self.key_image.move, dt)
    if gameWorld.playerInput:pressed('action') or gameWorld.playerInput:pressed('pause') then
      flux.to(self, 0.2, { fade = 1.0 }):oncomplete(function() gameWorld.gameState:setState('gameplay') end)
    end
  end
end

function Tutorial:updateImage(image, dt)
  image.timer = image.timer - dt
  if image.timer <= 0 then
    image.timer = image.timer + image.duration
    image.frame = image.frame + 1
    if image.frame > image.frames then image.frame = 1 end
  end
end

function Tutorial:draw()
  love.graphics.setColor(gameWorld.colors.white)
  love.graphics.clear(1.0, 1.0, 1.0, 1.0)
  love.graphics.draw(gameWorld.assets.backdrops.title_background, 0, 0)
  ----- Backsnow
  self.backsnow:draw()
  if self.page == 1 then
    ----- Animations
    love.graphics.draw(self.pour_image.image[self.pour_image.frame], self.pour_image.x, self.pour_image.y)
    love.graphics.draw(self.mouse_image.pour.image[self.mouse_image.pour.frame], self.mouse_image.pour.x, self.mouse_image.pour.y)
    love.graphics.draw(self.send_image.image[self.send_image.frame], self.send_image.x, self.send_image.y)
    love.graphics.draw(self.mouse_image.send.image[self.mouse_image.send.frame], self.mouse_image.send.x, self.mouse_image.send.y)
    ----- Text
    love.graphics.setFont(self.textfont)
    love.graphics.setColor(gameWorld.colors.menu_text)
    love.graphics.print("Pour - RMB / C / Gamepad B", 80, 100)
    love.graphics.print("Pour a drink from \nthe tap by pressing \nRMB. Each tap fills \nthe tankard with a \ndifferent drink.", 420, 150)
    love.graphics.print("Send - LMB / Z / Gamepad A", 840, 100)
    love.graphics.print("Send out a drink to\nthe patrons at the \nbar by pressing LMB. \nMake sure the drink \nyou send matches\ntheir order!", 680, 350)
    love.graphics.setColor(gameWorld.colors.white)
  elseif self.page == 2 then
    ----- Animations
    love.graphics.draw(self.swap_image.image[self.swap_image.frame], self.swap_image.x, self.swap_image.y)
    love.graphics.draw(self.mouse_image.swap.image[self.mouse_image.swap.frame], self.mouse_image.swap.x, self.mouse_image.swap.y)
    love.graphics.draw(self.move_image.image[self.move_image.frame], self.move_image.x, self.move_image.y)
    love.graphics.draw(self.key_image.move.image[self.key_image.move.frame], self.key_image.move.x, self.key_image.move.y)
    ----- Text
    love.graphics.setFont(self.textfont)
    love.graphics.setColor(gameWorld.colors.menu_text)
    love.graphics.print("Swap", 235, 75)
    love.graphics.print("Scroll or MMB / X / Gamepad X or Y", 35, 110)
    love.graphics.print("Hold two drinks at\nonce by swapping hands\nwith MMB. If your left\nhand is empty, you can\npour a second drink!\n\nYou can also send both\ndrinks out by pressing\nLMB twice.", 420, 320)
    love.graphics.print("Move", 1000, 75)
    love.graphics.print("WASD / Arrow Keys / Control Pad", 820, 110)
    love.graphics.print("Pick up empty tankards\nto collect an extra tip!", 580, 160)
    love.graphics.setColor(gameWorld.colors.white)
  end
  ----- Title
  --love.graphics.setFont(self.titlefont)
  --love.graphics.setColor(gameWorld.colors.credits_title)
  --love.graphics.print("TUTORIAL", 575, 25)
  love.graphics.setColor(gameWorld.colors.white)
  ----- Frontsnow
  love.graphics.setColor(gameWorld.colors.white)
  self.snow:draw()
  ----- Fade
  if self.fade > 0 then
    love.graphics.setColor(0.0, 0.0, 0.0, self.fade) --(0.0, 0.0, 0.0, self.fade)
    love.graphics.rectangle('fill', 0, 0, 1280, 720)
  end
end

return Tutorial
