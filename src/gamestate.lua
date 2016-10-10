
local gamestates = {}

local current = {}

function gamestates.load (gs)
  if current == gs then return end

  gamestates.close()
  current = gs
  if not current.initialised then
    if current.init then
      current:init()
      current.initialised = true
    end
  end
  if current.load then current:load() end
end

function gamestates.update ()
  if current.update then current:update() end
end

function gamestates.draw ()
  love.graphics.push()
  if current.draw then current:draw() end
  love.graphics.pop()
end

function gamestates.close ()
  if current.close then current:close() end
end

return gamestates
