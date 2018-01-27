local LoadState = {}

function LoadState:enter()

    --Controllers
    game.controller = {}
    game.controller.deadZone = 0.25
    game.controller.controllerList = love.joystick:getJoysticks()

    images = {}
    images.stalks = love.graphics.newImage('assets/images/stalks.png')
    images.wiggles = love.graphics.newImage('assets/images/wiggles.png')
    images.wiggles_dead = love.graphics.newImage('assets/images/wiggles_dead.png')

    State.switch(game.states.game)

end

return LoadState