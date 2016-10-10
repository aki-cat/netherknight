
local attack = module.entity:new {
  0, 0, 1, 1,
  __type = 'attack'
}

function attack:__init ()
  self.attack = 1
  self:unset_layer(2)
  self:unset_mask(1)
  self:set_layer(3)
  self:set_mask(2)
end

function attack:on_collision (somebody)
  if somebody:get_type() == 'monster' then
    local dmg = self.attack + gamedata.weapon:generate_dmg()
    somebody:take_damage(dmg, self.pos)
  end
end

function attack:draw ()
  local x, y = (self.pos * globals.unit):unpack()
  local w, h = (self.size * globals.unit):unpack()
  color:setRGBA(255, 255, 255, 100)
  --love.graphics.rectangle('fill', x - w / 2, y - h / 2, w, h )
  color:reset()
end

return attack
