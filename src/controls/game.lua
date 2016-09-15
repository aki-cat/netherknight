
local gameactions = {}

gameactions.input_move_player = {
  signal = 'holdkey',
  func = function (action)
    local movement = basic.vector:new {}
    local speed = globals.frameunit * globals.unit / 64
    local angle = math.pi -- 180 degrees

    if action == 'up' then
      movement:set(math.cos(angle * 3/2) * speed, math.sin(angle * 3/2) * speed)
      player:move(movement)
    elseif action == 'right' then
      movement:set(math.cos(angle * 0/2) * speed, math.sin(angle * 0/2) * speed)
      player:move(movement)
    elseif action == 'down' then
      movement:set(math.cos(angle * 1/2) * speed, math.sin(angle * 1/2) * speed)
      player:move(movement)
    elseif action == 'left' then
      movement:set(math.cos(angle * 2/2) * speed, math.sin(angle * 2/2) * speed)
      player:move(movement)
    end
  end
}

return require 'control' :new { actions = gameactions }
