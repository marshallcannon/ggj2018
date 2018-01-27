game = {}

State = require 'libraries/hump/gameState'

function love.load()

    game.width = 1920
    game.height = 1080
    love.window.setMode(game.width, game.height, {vsync='false', fullscreen = true, fullscreentype='desktop'})
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setBackgroundColor(255, 255, 255)

    State.registerEvents()
    game.states = {
        menu = nil,
        game = require 'states/game'
    }
    State.switch(game.states.game)


end