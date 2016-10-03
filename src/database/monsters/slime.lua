
local slime = {
  name = 'Blue Slime',
  size = basic.vector:new{ 1/2, 1/4 },
  maxhp  = 12,
  attack = 3,
}

local function action(self)
  while true do
    local angle = math.pi * 2 * love.math.random()
    local idle = love.math.random() * 3
    local count = 0
    local speed = globals.frameunit / 4
    local movement = speed * basic.vector:new{
      math.cos(angle),
      math.sin(angle)
    }
    local player = hump.gamestate.current():getentity('player')

    if idle < 1 then
      for i=1, globals.framerate * 0.5 do
        coroutine.yield()
      end
    elseif idle < 2 then
      for i=1, globals.framerate * 1.0 do
        self:move(movement)
        coroutine.yield()
      end
    else
      for i=1, globals.framerate * 0.5 do
        movement = (player.pos - self.pos):normalized() * speed
        self:move(movement)
        coroutine.yield()
      end
    end
  end
end

function slime:update()
  if not self.behaviour then
    self.behaviour = coroutine.create(action)
  end
  local status, info = coroutine.resume(self.behaviour, self)
  if not status then print(info) end
  assert(status, "Coroutine error!")
end

return slime
