
local gameactions = {}


gameactions.input_move_player = {
  signal = 'holdkey',
  func = function (action)
    local player = hump.gamestate.current().getplayer()
    local movement = basic.vector:new {}
    local speed = globals.frameunit * globals.unit / 64
    local angle = math.pi -- 180 degrees
    local condition = false
    local directions = {
      right      = angle * 0/4,
      down_right = angle * 1/4,
      down       = angle * 2/4,
      down_left  = angle * 3/4,
      left       = angle * 4/4,
      up_left    = angle * 5/4,
      up         = angle * 6/4,
      up_right   = angle * 7/4
    }
    for dir,_ in pairs(directions) do
      if dir == action then
        condition = true
        break
      end
    end
    if not condition then return end
    movement:set(speed * math.cos(directions[action]), speed * math.sin(directions[action]))
    player:move(movement)
  end
}

return require 'control' :new { actions = gameactions }
