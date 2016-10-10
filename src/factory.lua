
local factory = {}

local elements = require 'basic.pack' 'elements'

local window_width, window_height = love.window:getMode()
window_width, window_height = window_width / globals.unit, window_height / globals.unit

function factory.make_player (models)
  local id = unique_id:generate()
  local player = elements.player:new {}
  local actor = elements.actor:new { 'player' }
  local body = elements.body:new { 'knight', window_width / 2, window_height / 2 }
  local hitbox = elements.hitbox:new { 'knight', window_width / 2, window_height / 2, }
  local sprite = elements.sprite:new { 'knight' }
  local cam = elements.camera:new {}
  player:set_id(id)
  actor:set_id(id)
  body:set_id(id)
  hitbox:set_id(id)
  sprite:set_id(id)
  cam:set_id(id)
  models.player:add_element(player)
  models.actors:add_element(actor)
  models.physics:add_element(body)
  models.hitboxes:add_element(hitbox)
  models.sprites:add_element(sprite)
  models.camera:add_element(cam)
  return id
end

function factory.make_npc (models)
  local id = unique_id:generate()
  local body = elements.body:new { window_width / 4, window_height / 2, 1/2, 1/4 }
  local sprite = elements.sprite:new { 'knight' }
  body:set_id(id)
  sprite:set_id(id)
  models.physics:add_element(body)
  models.sprites:add_element(sprite)
  return id
end

function factory.make_slime (models)
  local id = unique_id:generate()
  local actor = elements.actor:new { 'slime' }
  local x, y = math.random(3, window_width - 4), math.random(3, window_height - 4)
  local body = elements.body:new { 'slime', x, y }
  local hitbox = elements.hitbox:new { 'slime', x, y }
  local sprite = elements.sprite:new { 'slime' }
  local behaviour = elements.behaviour:new { 'slime' }
  actor:set_id(id)
  body:set_id(id)
  hitbox:set_id(id)
  sprite:set_id(id)
  behaviour:set_id(id)
  models.actors:add_element(actor)
  models.physics:add_element(body)
  models.hitboxes:add_element(hitbox)
  models.sprites:add_element(sprite)
  models.behaviours:add_element(behaviour)
  return id
end

function factory.make_default_room (models)
  local id = unique_id:generate()
  local room = elements.room:new { 16, 10, 2 }
  local spritebatch = elements.spritebatch:new { 'default', room:get_tilemap() }
  room:set_id(id)
  spritebatch:set_id(id)
  models.map:add_element(room)
  models.spritebatch:add_element(spritebatch)
  return id
end

return factory
