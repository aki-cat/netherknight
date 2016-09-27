
local static_body = physics.collision_area:new {
  __type = 'static_body'
}

function static_body:on_collision (somebody)
  -- is this class even necessary?
end

return static_body
