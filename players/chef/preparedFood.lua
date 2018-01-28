local Item = require 'players/chef/item'

local PreparedFood = Class{
    __includes = Item
}

function PreparedFood:init(x, y, ingredients)

    Item.init(self, 'Prepared Food', x, y, images.preparedFood)

    self.ingredients = ingredients

end

return PreparedFood