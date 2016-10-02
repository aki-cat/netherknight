
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
  basic.signal:emit('entity_slain', self)
  gamedata.killcount = gamedata.killcount + 1
  basic.signal:emit('monster_slay', self)
  self.timer:after(0.05*8, function()
    local strength = (self.maxhp + self.attack) * gamedata.level
    basic.signal:emit('drop_money', strength, self.pos)
    basic.signal:emit('gain_exp', self)
    basic.signal:emit('entity_death', self)
  end)
end

function monster:on_collision (somebody, h, v)
  if somebody:get_type() == 'attack' then
    local dmg = somebody.attack + gamedata.weapon:generate_dmg()
    self:take_damage(dmg, somebody.pos)
  elseif somebody:get_type() == 'player' then
    local dmg = basic.dice.throw(2, self.attack)
    somebody:take_damage(dmg, self.pos)
  elseif somebody:get_type() == 'static_body' then
    self:stop(h, v)
  end
end

function monster:update (args)
  if not self:isdead() and self.think and type(self.think) == 'function' then self:think() end
  module.entity.update(self)
end

function monster:draw ()
  module.entity.draw(self) -- call entity draw
end

return monster
