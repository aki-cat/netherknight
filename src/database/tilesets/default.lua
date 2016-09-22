
local default = {}

default.img = love.graphics.newImage('assets/images/tileset.png')
default.tilesize = globals.unit
default.obstacles = {
  [5] = true,
  [6] = true,
  [7] = true,
  [8] = true,
  [9] = true,
  [10] = true,
  [11] = true,
  [12] = true,
  [13] = true,
  [14] = true,
  [15] = true,
  [16] = true,
}
default.dictionary = {
  [01] = 'ceiling',
  [02] = 'floor',
  [03] = 'floor-detail1',
  [04] = 'floor-detail2',
  [05] = 'wall-corner-top-left',
  [06] = 'wall-corner-top-right',
  [07] = 'wall-corner-inverted-top-left',
  [08] = 'wall-corner-inverted-top-right',
  [09] = 'wall-top',
  [09] = 'wall-right',
  [09] = 'wall-bottom',
  [09] = 'wall-left',
  [13] = 'wall-corner-bottom-left',
  [14] = 'wall-corner-bottom-right',
  [15] = 'wall-corner-inverted-bottom-left',
  [16] = 'wall-corner-inverted-bottom-right',
}

return default
