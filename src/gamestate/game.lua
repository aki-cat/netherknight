
local game = require 'gamestate' :new {}
local controller = controllers.game
local sprites = basic.pack 'database.sprites'

local bodies = {}
local drawables = {}

function game:init ()
  local player_body = require 'body' :new { globals.width / 2, globals.height / 2 }
  local player_sprite = require 'sprite' :new { sprites.slime }
  self:add_body('player', player_body)
  self:add_drawable('player', player_sprite)
end

function game:enter ()
  --local slime = require 'body' :new { globals.width / 4, globals.height / 4 }
  --self:add_body('slime00', slime)
  controller:connect()
end

function game:synchronize (bodyname)
  if self.drawables[bodyname] then
    local body = self.bodies[bodyname]
    local drawable = self.drawables[bodyname]
    drawable.pos:set(body.pos:unpack())
  end
end

function game:update ()
  for bname,body in pairs(self.bodies) do
    self:synchronize(bname)
    body:update()
  end
  for _,drawable in pairs(self.drawables) do
    drawable:update()
  end
end

function game:draw ()
  love.graphics.push()

  love.graphics.scale(globals.unit)
  for _,body in pairs(self.bodies) do
    body:draw()
  end
  for _,drawable in pairs(self.drawables) do
    drawable:draw()
  end

  love.graphics.pop()
end

function game:leave ()
  controller:disconnect()
end

return game
