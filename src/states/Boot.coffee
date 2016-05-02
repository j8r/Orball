OrballBoot = ->
  music: null
  orientated: false
  init: ->
    # set up input max pointers
    @input.maxPointers = 1
    # set up stage disable visibility change
    @stage.disableVisibilityChange = true
    @scale.scaleMode = Phaser.ScaleManager.SHOW_ALL
    @scale.pageAlignHorizontally = true
    @scale.pageAlignVertically = true
    @scale.setResizeCallback @gameResized, @
    return
  preload: ->
    @stage.backgroundColor = '#7799AA'
    @load.image 'PreloadBar', 'assets/preloader.gif'
    return

  create: ->
    @state.start 'Preload'
    return

  gameResized: (width, height) ->
    return

  enterIncorrectOrientation: ->
    BasicGame.orientated = false
    document.getElementById 'orientation'.style.display = 'block'
    return

  leaveIncorrectOrientation: ->
    BasicGame.orientated = true
    document.getElementById 'orientation'.style.display = 'none'
    return
