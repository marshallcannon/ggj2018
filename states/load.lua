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
    images.miniStalks = love.graphics.newImage('assets/images/miniStalks.png')
    images.miniStalks_dead = love.graphics.newImage('assets/images/miniStalks_dead.png')
    images.wiggles = love.graphics.newImage('assets/images/wiggles.png')
    images.wiggles_dead = love.graphics.newImage('assets/images/wiggles_dead.png')
    images.shelly = love.graphics.newImage('assets/images/shelly.png')
    images.shelly_dead = love.graphics.newImage('assets/images/shelly_dead.png')
    images.teeth = love.graphics.newImage('assets/images/teeth.png')
    images.teeth_dead = love.graphics.newImage('assets/images/teeth_dead.png')
    images.eyeGuy = love.graphics.newImage('assets/images/eyeGuy.png')
    images.eyeGuy_dead = love.graphics.newImage('assets/images/eyeGuy_dead.png')

    State.switch(game.states.game)

end

return LoadState