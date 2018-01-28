local Monster = require 'monsters/monster'

local Wiggles = Class{
    __includes = Monster
}

function Wiggles:init(x, y, direction)

    Monster(x, y, images.wiggles, direction)

end

return Wiggles