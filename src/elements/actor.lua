
local actor = require 'element' :new {
  'slime',
  __type = 'actor'
}

local STAGGER = 0.5

function actor:__init ()
  local source = require('database.actors.' .. self[1])
  self.maxhp = source.maxhp
  self.attack = source.attack
  self.harmful = source.harmful
  self.damage = 0
  self.immune = false
  self.timer = require 'basic.timer' :new {}
end

function actor:get_current_hp ()
  return self.maxhp - self.damage
end

function actor:get_max_hp ()
  return self.maxhp
end

function actor:get_attack ()
  return self.attack
end

function actor:set_attack (atk)
  self.attack = atk
end

function actor:get_harm_level ()
  return self.harmful
end

function actor:set_harm_level (lvl)
  self.harmful = lvl
end

function actor:is_dead ()
  return self.maxhp <= self.damage
end

function actor:take_damage (harmful)
  if self.immune then return end
  local dmg = harmful:get_attack()
  self.immune = true
  self.damage = math.min(self.damage + dmg, self.maxhp)
  self.timer:after(STAGGER, function() self.immune = false end)
  signal.broadcast('take_damage', self:get_id(), harmful:get_id(), dmg, STAGGER)
end

function actor:update ()
  self.timer:update()
end

return actor
