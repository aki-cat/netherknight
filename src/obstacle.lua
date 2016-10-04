
local obstacle = physics.physical_body:new {
  __type = 'obstacle'
}

--[[

== layers and masks ==

obstacles must collide with every entity's body
obstacles must not with every entity's hitbox

entities' bodies should not collide with each other
but they should collide with obstacles

entities' hitboxes shoud collide with each other

obstacles
  is in layers: 1

entity body
  is in layers: 2
  collide with: 1

entity hitbox
  is in layers: 3
  collide with: 3

]]

function obstacle:__init ()
  self:set_layer(1)
end

return obstacle
