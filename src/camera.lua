
local camera = physics.dynamic_body:new {
  shape = 'rectangle',
  centred = true,
  __type = 'camera'
}

function camera:__init()
  self.target = self.pos
  self.size:set(globals.width, globals.height)
end

function camera:set_target (body)
  self.target = body.pos
end

function camera:update()
  physics.dynamic_body.update(self)
  self:move( 0.5 * delta * (self.target - self.pos) )
end

function camera:draw()
  love.graphics.scale(1/globals.unit)
  local translation = (self.pos - self.size/2) * globals.unit
  translation:set(math.floor(translation.x), math.floor(translation.y))
  --print(self.pos:unpack())
  --print(translation:unpack())
  love.graphics.translate((-translation):unpack())
  love.graphics.scale(globals.unit)

end

return camera
