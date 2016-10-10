
local notifications = require 'controller' :new {
  __type = 'notifications'
}

local texts = {}

function notifications:clear ()
  for index, text in pairs(texts) do
    texts[index] = nil
  end
end

function notifications:update ()
  for index, text in pairs(texts) do
    text:update()
  end
end

function notifications:draw ()
  for _, text in pairs(texts) do
    text:draw()
  end
end

function notifications:__init ()
  self.actions = {
    {
      signal = 'add_text',
      func = function (text)
        texts[text] = text
      end
    },
    {
      signal = 'remove_text',
      func = function (text)
        texts[text] = nil
      end
    },
    {
      signal = 'clear_notifications',
      func = function ()
        self:clear()
      end
    },
  }
end

return notifications:new {}
