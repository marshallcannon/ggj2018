local LoadState = {}

function LoadState:enter()

    --Controllers
    game.controller = {}
    game.controller.deadZone = 0.1
    game.controller.controllerList = love.joystick:getJoysticks()

    State.switch(game.states.game)

end

return LoadState