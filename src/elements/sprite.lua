
local sprite = require 'element' :new {
  'dummy',
  __type = 'sprite'
}

function sprite:__init ()
  local database = require 'basic.pack' 'database.sprites'
  local resource = database[self[1]]
  self.pos = require 'basic.vector' :new {}
  self.timer = require 'basic.timer' :new {}
  self.scalex = resource[6]
  self.scaley = resource[7] or self.scalex
  self.rotation = 0
  self.fliph = false
  self.flipv = false
  self.animations = resource.animations
  self.state = 'default'
  self.drawable = {}
  self.frame = 1
  self.brightness = 255
  self.alpha = 255
  self.drawable = table.pack(table.unpack(resource))
  self:play_animation()
end

function sprite:play_animation ()
  local animation = self.animations[self.state]
  if not animation then
    print('No animation to play from', self)
    return
  end
  self.frame = 1
  self.timer:clear()
  if animation.oneshot then
    self.timer:every(
      animation.step,
      function ()
        self.frame = self.frame + 1
      end,
      #animation.frames - 1
    )
  else
    self.timer:every(
      animation.step,
      function ()
        self.frame = self.frame % #animation.frames + 1
      end
    )
  end
end

function sprite:set_animation (animation_name)
  if self.state ~= animation_name and self.animations[animation_name] then
    self.state = animation_name
    self:play_animation()
  end
end

function sprite:freeze_animation ()
  self.timer:clear()
end

function sprite:set_pos (x, y, z)
  self.pos:set(x, y, z)
end

function sprite:get_pos ()
  return self.pos * 1
end

function sprite:set_frame (i)
  self.frame = i
end

function sprite:get_frame ()
  return self.animations[self.state].frames[self.frame]
end

function sprite:get_quad ()
  return self:get_frame()[1]
end

function sprite:get_offset ()
  return table.unpack(self:get_frame()[2])
end

function sprite:set_flip_h (enable)
  self.fliph = enable
end
function sprite:set_flip_v (enable)
  self.flipv = enable
end

function sprite:set_scale (axis, s)
  if     axis == 'h' then self.scalex = s
  elseif axis == 'v' then self.scaley = s end
end

function sprite:set_rotation (r)
  self.rotation = r
end

function sprite:set_brightness (b)
  self.brightness = b or 255
end

function sprite:set_alpha (a)
  self.alpha = a or 255
end

function sprite:update ()
  self.timer:update()
  self.drawable[2] = self:get_quad()
  self.drawable[3], self.drawable[4] = self.pos:unpack()
  self.drawable[5] = self.rotation
  self.drawable[6] = self.fliph and -self.scalex or self.scalex
  self.drawable[7] = self.flipv and -self.scaley or self.scaley
  self.drawable[8], self.drawable[9] = self:get_offset()
end

function sprite:draw ()
  local colors = require 'effects.colors'
  colors.setHSLA(0, 0, self.brightness, self.alpha)
  love.graphics.draw(table.unpack(self.drawable))
  colors.reset()
end

return sprite
