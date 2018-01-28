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
    images.miniStalks_dead_resize = love.graphics.newImage('assets/images/miniStalks_dead_resize.png')
    images.wiggles = love.graphics.newImage('assets/images/wiggles.png')
    images.wiggles_dead = love.graphics.newImage('assets/images/wiggles_dead.png')
    images.shelly = love.graphics.newImage('assets/images/shelly.png')
    images.shelly_dead = love.graphics.newImage('assets/images/shelly_dead.png')
    images.teeth = love.graphics.newImage('assets/images/teeth.png')
    images.teeth_dead = love.graphics.newImage('assets/images/teeth_dead.png')
    images.eyeGuy = love.graphics.newImage('assets/images/eyeGuy.png')
    images.eyeGuy_dead = love.graphics.newImage('assets/images/eyeGuy_dead.png')
    images.preparedFood = love.graphics.newImage('assets/images/preparedFood.png')
    images.arrow = love.graphics.newImage('assets/images/arrow.png')
    images.background1 = love.graphics.newImage('assets/images/background1.png')
    images.background2 = love.graphics.newImage('assets/images/background2.png')
    images.portal = love.graphics.newImage('assets/images/portal.png')
    images.plate = love.graphics.newImage('assets/images/plate.png')
    images.trashcan = love.graphics.newImage('assets/images/trash.png')

    images.menuBackground_tile = love.graphics.newImage('assets/images/title_tile.png')
    images.menuBackground_noTile = love.graphics.newImage('assets/images/title_noTile.png')
  
    images.table = love.graphics.newImage('assets/images/table.png')
    images.pot_empty = love.graphics.newImage('assets/images/pot_empty.png')
    images.pot_cooking = love.graphics.newImage('assets/images/pot_cooking.png')
    images.pot_done = love.graphics.newImage('assets/images/pot_done.png')
    images.pot_burnt = love.graphics.newImage('assets/images/pot_burnt.png')
    
    images.chef = {}
    images.chef.sheet = love.graphics.newImage('assets/images/chef2.png')
    images.chef.down = love.graphics.newQuad(0, 0, 32, 32, images.chef.sheet:getDimensions())
    images.chef.right = love.graphics.newQuad(32, 0, 32, 32, images.chef.sheet:getDimensions())
    images.chef.up = love.graphics.newQuad(64, 0, 32, 32, images.chef.sheet:getDimensions())
    images.chef.left = love.graphics.newQuad(96, 0, 32, 32, images.chef.sheet:getDimensions())

    fonts = {}
    fonts.mainHuge = love.graphics.newFont('assets/fonts/slkscre.ttf', 128)
    fonts.mainLarge = love.graphics.newFont('assets/fonts/slkscre.ttf', 64)
    fonts.mainSmall = love.graphics.newFont('assets/fonts/slkscre.ttf', 32)

    game.itemList = require 'players/chef/items'
    game.levels = require 'listOfLevels'

    game.redShader = love.graphics.newShader( [[

        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
            vec4 pixel = Texel(texture, texture_coords);
            pixel.r = 1;
            pixel.g = 0;
            pixel.b = 0;
            return pixel;
        }

    ]])

    State.switch(game.states.menu)

end

return LoadState