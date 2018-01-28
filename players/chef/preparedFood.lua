local Item = require 'players/chef/item'

local PreparedFood = Class{
    __includes = Item
}

function PreparedFood:init(ingredients)

    self.ingredients = ingredients

end

return PreparedFood