
local gameplay = {}

local factory = require 'factory'

function gameplay:init()
  self.models = require 'basic.pack' 'models.dungeon'
  self.controllers = require 'basic.pack' 'controllers.dungeon'
end

function gameplay:load()
  -- connect all controllers
  signal.connect(self.controllers.player)
  signal.connect(self.controllers.actors)
  signal.connect(self.controllers.behaviours)
  signal.connect(self.controllers.bodies)
  signal.connect(self.controllers.hitboxes)
  signal.connect(self.controllers.camera)
  signal.connect(self.controllers.rooms)
  signal.connect(self.controllers.sprites)

  -- create first elements
  factory.make_player(self.models)
  factory.make_slime(self.models)
  factory.make_slime(self.models)
  factory.make_slime(self.models)
  signal.broadcast('set_room', factory.make_default_room(self.models))

  print("GAMEPLAY LOADED!")
end

function gameplay:update()
  -- update controllers
  self.controllers.player:update()
  self.controllers.actors:update()
  self.controllers.behaviours:update()
  self.controllers.bodies:update()
  self.controllers.hitboxes:update()
  self.controllers.sprites:update()
  self.controllers.rooms:update()
  self.controllers.camera:update()

  -- update models
  self.models.player:update()
  self.models.actors:update()
  self.models.hitboxes:update()
  self.models.physics:update()
  self.models.behaviours:update()
  self.models.map:update()
  self.models.spritebatch:update()
  self.models.sprites:update()
  self.models.camera:update()
end

function gameplay:draw()
  -- render everything
  self.models.camera:draw()
  self.models.player:draw()
  self.models.behaviours:draw()
  self.models.actors:draw()
  self.models.spritebatch:draw()
  self.models.map:draw()
  self.models.physics:draw()
  self.models.hitboxes:draw()
  self.models.sprites:draw()
end

function gameplay:close()
  -- disconnect all controllers
  signal.disconnect(self.controllers.player)
  signal.disconnect(self.controllers.actors)
  signal.disconnect(self.controllers.behaviours)
  signal.disconnect(self.controllers.bodies)
  signal.disconnect(self.controllers.hitboxes)
  signal.disconnect(self.controllers.sprites)
  signal.disconnect(self.controllers.rooms)
  signal.disconnect(self.controllers.camera)
end

return gameplay
