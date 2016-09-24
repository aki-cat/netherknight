
local monsters = basic.pack 'database.monsters'

local monster = module.entity:new {
  species = 'slime',
  __type = 'monster'
}

function monster:__init ()
  self.size = monsters[self.species].size
  self.maxhp = monsters[self.species].maxhp or self.maxhp
  self.attack = monsters[self.species].attack
  self.think = monsters[self.species].update
end

function monster:on_death ()
  audio:playSFX('Die')
  hump.signal.emit('monster_slay', self)
  self.timer:after(0.0666*6, function()
    local strength = (self.maxhp + self.attack) * gamedata.level
    hump.signal.emit('drop_money', strength, self.pos)
    hump.signal.emit('entity_death', self)
  end)
end

function monster:on_collision (somebody, h, v)
  if somebody:get_type() == 'attack' then
    self:take_damage(somebody.attack, somebody.pos)
  elseif somebody:get_type() == 'player' then
    somebody:take_damage(self.attack, self.pos)
  elseif somebody:get_type() == 'collision_body' then
    self:stop(h, v)
  end
end

function monster:update (args)
  if not self:isdead() and self.think and type(self.think) == 'function' then self:think() end
  hump.signal.emit('entity_turn', self, self.dir)
  module.entity.update(self)
end

function monster:draw ()
  module.entity.draw(self) -- call entity draw
end

return monster
