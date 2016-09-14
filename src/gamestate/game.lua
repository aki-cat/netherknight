
local globals = require 'globals'
local class = orangelua.pack 'class'
local resource_sprites = orangelua.pack 'resource.sprites'

local model, view

local game = class.gamestate:new {}

local slime = class.sprite:new(resource_sprites.slime)

function game:init()
  slime:setpos(globals.width/2, globals.height/2)
end

function game:enter()
  self.display:addchild(slime)
end

--function game:update()
--end


--function game:draw()
--end


function game:leave()
  self.display:remchild(slime)
end

return game
