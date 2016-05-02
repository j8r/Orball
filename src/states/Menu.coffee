OrballMenu = ->
  create: ->
    @logo = @add.sprite @world.centerX, 200, 'ball'
    # Set the anchor to the center of the sprite
    @logo.anchor.setTo 0.5, 0.5
    #@add.sprite 0, 0, 'sky'
    @startButton = @add.button @world.centerX, @world.centerY, 'button-start', @startGame, @, 2, 0, 1
    @startButton.anchor.set 0.5, 0.5
    @startButton.input.useHandCursor = true
    # button to "read the article"
    return
  startGame: (pointer) ->
    @state.start 'Game'
    return
