game = {}

State = require 'libraries/hump/gameState'
Class = require 'libraries/hump/class'
Vector = require 'libraries/hump/vector'
Timer = require 'libraries/hump/timer'
HC = require 'libraries/hc'
Sprite = require 'sprites/sprite'
Group = require 'util/group'

function love.load()

    game.width = 1920
    game.height = 1080
    game.scaledWidth = game.width/4
    game.scaledHeight = game.height/4
    love.window.setMode(game.width, game.height, {vsync='false', fullscreen = false, fullscreentype='desktop'})
    love.graphics.setDefaultFilter('nearest', 'nearest')

    game.gravity = 800

    State.registerEvents()
    game.states = {
        load = require 'states/load',
        menu = require 'states/menu',
        game = require 'states/game'
    }
    State.switch(game.states.load)


end