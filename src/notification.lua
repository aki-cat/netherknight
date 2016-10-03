
local notification = basic.prototype:new {
  'damage',
  0, 0,
  value = 1,
  time = 2,
  __type = 'notification'
}

local boxsize = 256

function notification:__init ()
  if self:__super() == basic.prototype then return end
  self.kind = self[1]
  self.pos = basic.vector:new { self[2], self[3] }
  self.alpha = 255
  self.intensity = (self.kind == 'level') and 2 or 1

  if self.value then
    if self.value >= 100 then
      self.intensity = 2
    elseif self.value >= 1000 then
      self.intensity = 3
    elseif self.value >= 9999 then
      self.intensity = 4
    end
  end

  basic.signal:emit('add_text', self)
  basic.timer:during(
    self.time,
    function ()
      self.pos.y = self.pos.y - .5/globals.unit
      self.alpha = self.alpha - 3
    end,
    function ()
      basic.signal:emit('remove_text', self)
    end
  )
end

function notification:update ()
  -- what?
end

function notification:draw ()
  love.graphics.push()

  -- setting up params
  love.graphics.scale(1/globals.unit)
  local pos = self.pos * globals.unit
  local displaytext = (self.value and self.value or '') .. (self.text and (' '..self.text) or '')

  -- set color and font
  if self.kind == 'damage' then
    color:setRGBA(255,0,0,self.alpha)
  elseif self.kind == 'heal' then
    color:setRGBA(50,255,50,self.alpha)
  else
    color:setRGBA(255,255,255,self.alpha)
  end
  fonts:set(self.intensity + 1)

  -- print text
  love.graphics.printf( displaytext, pos.x - boxsize/2, pos.y, boxsize, 'center')
  color:reset()

  love.graphics.pop()
end

return notification
