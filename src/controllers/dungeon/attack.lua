
local attack = require 'controller' :new { 'dungeon' }

function attack:__init ()
  local attack_model = self:get_model('attack')
  local actors_model = self:get_model('actors')
  local player_model = self:get_model('player')
  local sprite_model = self:get_model('sprites')
  local hitbox_model = self:get_model('hitboxes')

  local basic_slash_id = unique_id:generate()
  local basic_slash_attack = require 'elements.attack' :new (require 'database.attack.basic_slash')
  local basic_slash_hitbox = require 'elements.hitbox' :new { 'slash', -800, -800, }
  local basic_slash_sprite = require 'elements.sprite' :new { 'slash' }
  basic_slash_attack:set_id(basic_slash_id)
  basic_slash_hitbox:set_id(basic_slash_id)
  basic_slash_sprite:set_id(basic_slash_id)

  self:register_action('collision', function (id1, id2)
    local a1 = attack_model:get_element(id1)
    local a2 = attack_model:get_element(id2)
    local b1 = actors_model:get_element(id1)
    local b2 = actors_model:get_element(id2)
    local atk = a1 or a2
    local act = b1 or b2
    if not atk or not act then return end

    if atk:is_harmful_to(act:get_harm_level()) then
      act:take_damage(atk)
    end
  end)

  self:register_action('slash_attack', function (player_id)
    local player = player_model:get_element(player_id)
    local player_body = hitbox_model:get_element(player_id)
    if not player or not player_body then return end

    local pos = player_body:get_area():get_pos()
    local dir = player:get_face()

    local EPSILON = (1/globals.unit)^2
    if dir.x < -EPSILON then
      basic_slash_sprite:set_flip_h(false)
    elseif dir.x > EPSILON then
      basic_slash_sprite:set_flip_h(true)
    end

    basic_slash_hitbox:set_pos(pos + dir * 1)
    basic_slash_sprite:set_pos((pos + dir * 1):unpack())

    attack_model:add_element(basic_slash_attack)
    hitbox_model:add_element(basic_slash_hitbox)
    sprite_model:add_element(basic_slash_sprite)

    basic_slash_attack:start()
  end)

end

return attack:new {}
