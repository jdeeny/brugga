-- require "requires"

function love.load()
  print("LOAD")
end

function love.update(dt)
end

function love.draw()
  love.graphics.setColor(255, 255, 255, 255)
end

function love.focus(f)
  if f then
    love.mouse.setVisible(false)
    love.mouse.setGrabbed(true)
  else
    love.mouse.setVisible(true)
    love.mouse.setGrabbed(false)
    -- if state == STATE_PLAY then
    --  pause.enter()
    -- end
  end
end
