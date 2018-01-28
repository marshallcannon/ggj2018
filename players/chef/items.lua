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
    image = images.wiggles
}
function Items.Wiggles:init(x, y)
    Item.init(self, 'Wiggles', x, y)
end

return Items