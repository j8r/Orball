OrballPreload = ->
  preload: ->
    @preloadBar = @game.add.sprite @world.centerX, @world.centerY, 'PreloadBar'
    @load.setPreloadSprite @preloadBar, 0.5, 0.5
    @load.image 'ball', 'assets/ball.png'
    @load.image 'bg', 'assets/bg.png'
    @load.image 'ground', 'assets/platform.png'
    @load.image 'floor', 'assets/floor.png'
    @load.image 'star', 'assets/star.png'
    @load.image 'hole', 'assets/hole.png'
    @load.image 'diamond', 'assets/diamond.png'
    @load.image 'yellowBlock', 'assets/yellow-block.png'
    @load.image 'coin', 'assets/goldCoin.png'
    @load.spritesheet 'dude', 'assets/dude.png', 32, 48
    #  Buttons
    @load.spritesheet 'button-start', 'assets/button-start.png', 146, 51
    return
  create: ->
    @state.start 'Menu'
    return
