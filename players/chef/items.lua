local Item = require 'players/chef/item'

local Items = {}

function Items:getTotalNumberOfItems()
    local count = 0
    for key, item in pairs(self) do
        count = count + 1
    end
    --Remove this function from the count
    return count - 1
end

Items.Wiggles = Class{
    __includes = Item,
    image = images.wiggles_dead
}
function Items.Wiggles:init(x, y)
    Item.init(self, 'Wiggles', x, y)
end

Items.Hunter = Class{
    __includes = Item,
    image = images.teeth_dead
}
function Items.Hunter:init(x, y)
    Item.init(self, 'Hunter', x, y)
end

Items.Shelly = Class{
    __includes = Item,
    image = images.shelly_dead
}
function Items.Shelly:init(x, y)
    Item.init(self, 'Shelly', x, y)
end

Items.MiniStalk = Class{
    __includes = Item,
    image = images.miniStalks_dead_resize
}
function Items.MiniStalk:init(x, y)
    Item.init(self, 'MiniStalk', x, y)
end

return Items