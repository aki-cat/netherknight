
local attack = module.entity:new {
  0, 0, 4/5, 4/5,
  __type = 'attack'
}

function attack:__init ()
  self.attack = 1
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
