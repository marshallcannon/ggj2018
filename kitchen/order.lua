local Order = Class{

}

function Order:init(ingredients, time)

    self.ingredients = ingredients
    self.timeMax = time or 20

    self.timer = self.timeMax
    self.active = false
    self.position = Vector(0, 0)
    self.color = {255, 255, 255}
    self.slot = nil
    self.difficulty = 1

end

function Order:update(dt)

    if self.active then

        if self.timer >= 0 then
            self.timer = self.timer - dt
        end

        if self.timer <= 0 then
            self:fail()
        end

    end

end

function Order:draw()

    if self.active then

        love.graphics.setColor(self.color)
        love.graphics.rectangle('fill', self.position.x, self.position.y, 64, 32)
        love.graphics.setColor(150, 150, 150)
        love.graphics.rectangle('line', self.position.x, self.position.y, 64, 32)
        
        love.graphics.setColor(255, 255, 255)
        for i,ingredient in pairs(self.ingredients) do
            love.graphics.draw(ingredient.image, self.position.x+3+((i-1)%2)*12, self.position.y+1+math.floor((i-1)/2)*12,
                0.5, 0.5)
        end

        love.graphics.draw(images.arrow, self.position.x+32, self.position.y)

        local ratio = self.timer/self.timeMax
        love.graphics.setColor((1-ratio)*255, ratio*255, 0)
        love.graphics.rectangle('fill', self.position.x+1, self.position.y + 27, 62*ratio, 4)

    end

end

function Order:checkIfIngredientsMatch(ingredients)

    local correctIngredients = 0
    for i, ingredient in ipairs(self.ingredients) do
        for j, foodIngredient in ipairs(ingredients) do
            if ingredient == foodIngredient then
                correctIngredients = correctIngredients + 1
                table.remove(ingredients, j)
                break
            end
        end
    end

    if correctIngredients == #self.ingredients then
        return true
    end

end

function Order:activate(x)

    self.active = true
    self.position.x = x
    self.position.y = 270
    Timer.tween(0.5, self, {position = {y = 270-7-32}}, 'in-quad')

end

function Order:complete()

    self.color = {30, 237, 75}
    game.score = game.score + (self.timer/self.timeMax)*100*(self.difficulty/2)
    self:slideOut()

end

function Order:fail()

    self.color = {237, 30, 30}
    self:slideOut()

end

function Order:slideOut()

    Timer.tween(0.5, self, {position = {y = 270}}, 'in-quad', function() self:close() end)

end

function Order:close()

    self.active = false
    self.slot.order = nil

end

function Order:clone()

    return Order(self.ingredients, self.timeMax)

end

return Order