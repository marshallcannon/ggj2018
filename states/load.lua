local LoadState = {}

function LoadState:enter()

    --Controllers
    game.controller = {}
    game.controller.deadZone = 0.25
    game.controller.controllerList = love.joystick:getJoysticks()

    images = {}
    images.wizard_shoot = love.graphics.newImage('assets/images/wizard_shoot.png')
    images.wizard_hold = love.graphics.newImage('assets/images/wizard_hold.png')
    images.stalks = love.graphics.newImage('assets/images/stalks.png')
    images.wiggles = love.graphics.newImage('assets/images/wiggles.png')
    images.wiggles_dead = love.graphics.newImage('assets/images/wiggles_dead.png')
    images.table = love.graphics.newImage('assets/images/table.png')
    images.pot_empty = love.graphics.newImage('assets/images/pot_empty.png')
    images.pot_full = love.graphics.newImage('assets/images/pot_full.png')
    
    images.chef = {}
    images.chef.sheet = love.graphics.newImage('assets/images/chef.png')
    images.chef.down = love.graphics.newQuad(0, 0, 32, 32, images.chef.sheet:getDimensions())
    images.chef.right = love.graphics.newQuad(32, 0, 32, 32, images.chef.sheet:getDimensions())
    images.chef.up = love.graphics.newQuad(64, 0, 32, 32, images.chef.sheet:getDimensions())
    images.chef.left = love.graphics.newQuad(96, 0, 32, 32, images.chef.sheet:getDimensions())

    State.switch(game.states.game)

end

return LoadState