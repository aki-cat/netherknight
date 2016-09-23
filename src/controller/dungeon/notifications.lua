
local drawtext = require 'controller' :new {
  __type = 'drawtext'
}

local texts = {}

function drawtext:clear ()
  for index, text in pairs(texts) do
    texts[index] = nil
  end
end

function drawtext:update ()
  for index, text in pairs(texts) do
    text:update()
  end
end

function drawtext:draw ()
  for _, text in pairs(texts) do
    text:draw()
  end
end

function drawtext:__init ()
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
  }
end

return drawtext:new {}
