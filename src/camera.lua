
local camera = physics.dynamic_body:new {
  shape = 'rectangle',
  centred = true,
  __type = 'camera'
}

function camera:valid_entity (entity)
  if (entity.pos - self.pos) * (entity.pos - self.pos) < (globals.width^2 + globals.height^2)/2 then
    return true
  end
end

function camera:__init()
  self.target = self.pos
  self.size:set(globals.width, globals.height)
end

function camera:set_target (body)
  self.target = body.pos
  self.pos:set(body.pos:unpack())
end

function camera:update()
  --physics.dynamic_body.update(self)
  --local speed = 1/2
  --local distvec = self.target - self.pos
  --self:move( distvec * speed * delta )
  self.pos = self.target * 1
end

function camera:draw()
  local translation = (self.pos - self.size/2) * globals.unit
  translation:set(math.floor(.5 + translation.x), math.floor(.5 + translation.y))
  --print(self.pos:unpack())
  --print(translation:unpack())
  love.graphics.translate((-translation):unpack())
end

return camera
