OrballGame = ->
  score = 0
  newItem = undefined
  create: ->
    #  Enable Arcade Physics system
    @game.physics.startSystem Phaser.Physics.ARCADE
    #@game.add.sprite 0, 0, 'sky'
    @stage.backgroundColor = '#5555AA'
    #  The scrolling background
    @bg = @game.add.tileSprite 0, 510, @game.world.width, @game.world.height, 'bg'
    #  The platforms group contains the ground and the 2 ledges we can jump on
    #@platforms = @game.add.group()
    #  Enable physics for objects created in this group
    #@platforms.enableBody = true
    #  Ground
    #@ground = @platforms.create 0, @game.world.height - 64, 'ground'
    #  Scale it to fit the width of the game (the original sprite is 400x32 in size)
    #@ground.scale.setTo 6, 6
    #  This stops it from falling away when you jump on it
    #@ground.body.immovable = true
    #  Now let's create two ledges
    #@ledge = @platforms.create 400, 600, 'ground'
    #@ledge.body.immovable = true
    #@ledge = @platforms.create -150, 250, 'ground'
    #@ledge.body.immovable = true
    #initiate groups, we'll recycle elements

    #game params
    @levelSpeed = -250
    @tileSize = 70
    @probCliff = 0.4
    @probVertical = 0.4
    @probMoreVertical = 0.5
    @friction = 0.6
    #  Add floors
    @floors = @game.add.group()
    @floors.enableBody = true
    #keep track of the last floor
    @lastFloor = newItem
    #keep track of the last element
    @lastCliff = false
    @lastVertical = false
    @verticalObstacles = @game.add.group()
    @verticalObstacles.enableBody = true
    @verticalObstacles.createMultiple 12, 'yellowBlock'
    @verticalObstacles.setAll 'checkWorldBounds', true
    @verticalObstacles.setAll 'outOfBoundsKill', true
    i = 0
    #  Genereate first floors
    while i < @game.world.width/80
      newItem = @floors.create i * @tileSize, @game.world.height - @tileSize, 'floor'
      newItem.body.immovable = true
      newItem.body.velocity.x = @levelSpeed
      i++
    # Coins group
    @coins = @game.add.group()
    @coins.enableBody = true
    #  Keep track of the last floor
    @lastFloor = newItem
    #  The ballPlayer and its settings
    @ballPlayer = @game.add.sprite 32, @game.world.height - 150, 'ball'
    #  We need to enable physics on the ballPlayer
    @game.physics.arcade.enable @ballPlayer
    #  Camera follows the ballPlayer
    @game.camera.follow @ballPlayer
    #  ballPlayer physics properties, slight bounce.
    #@ballPlayer.body.bounce.y = 0.3
    @ballPlayer.body.gravity.y = 400
    @ballPlayer.body.collideWorldBounds = true
    @ballPlayer.anchor.setTo 0.5, 1
    #  Our two animations, walking left and right.
    #@ballPlayer.animations.add 'left', [0, 1, 2, 3], 10, true
    #@ballPlayer.animations.add 'right', [5, 6, 7, 8], 10, true
    #  Finally some stars to collect
    @stars = @game.add.group()
    #  We will enable physics for any star that is created in this group
    @stars.enableBody = true
    #  Here we'll create 12 of them evenly spaced apart
    star = 0
    #  Generate stars
    while star < 3
      #  Create a star inside of the 'stars' group
      @star = @stars.create star * 70, 0, 'star'
      #  Let gravity do its thing
      @star.body.gravity.y = 400
      #  This just gives each star a slightly random bounce value
      @star.body.bounce.y = 0.5 + Math.random() * 0.2
      star++
    #  The score
    @scoreText = @game.add.text 16, 16, 'Score: 0', fontSize: '32px', fill: '#ADD'
    #  Controls
    @cursors = @game.input.keyboard.createCursorKeys()
    #@moveButton.space = @game.input.keyboard.addKey Phaser.Keyboard.SPACEBAR
    @moveButton = @game.input.activePointer
    #  Enable input down duration time
    @game.input.onUp.add @downTime, @
    @game.input.onDown.add @upTime, @
    # Time
    @time = 0
    @upDuration = 0
    @timerText = @game.add.text 15, 50, "Time: "+ @time, @fontBig
    #@timerTex = @game.add.text 15, 80, "Time: "+ @upDuration, @fontBig
    @game.time.events.loop Phaser.Timer.SECOND * 0.1, @updateTime, @
    @game.time.events.loop Phaser.Timer.SECOND * 0.1, @upTime, @
    return
  update: ->
    #  Collide the ballPlayer and the stars with the platforms
    @game.physics.arcade.collide @ballPlayer, @floors
    @game.physics.arcade.collide @stars, @floors
    @game.physics.arcade.collide @ballPlayer, @verticalObstacles, @playerHit, null, @
    #  Checks to see if the ballPlayer overlaps with any of the stars, if he does call the collectStar function
    @game.physics.arcade.overlap @ballPlayer, @stars, @collectStar, null, @
    #  Background speed
    @bg.tilePosition.x += @levelSpeed/100
    #  Reset the ballPlayers velocity (movement)
    @ballPlayer.body.velocity.x = @ballPlayer.body.velocity.x/2
    if @ballPlayer.body.touching.down
      @ballPlayer.body.velocity.x = (@ballPlayer.body.velocity.x - @levelSpeed)/2

    #  Jump if button up-down-up or down-up-down  quickly
    if (@moveButton.isDown && 0 < @upDuration < 3 || 0 < @downDuration < 400) && @ballPlayer.body.touching.down
      @ballPlayer.body.velocity.y = -300
      #  Scroll the background

    else if @moveButton.isDown && @ballPlayer.body.touching.down
      @ballPlayer.body.velocity.x = 100 - @levelSpeed

    else if @moveButton.isDown
      #  Move to the right
      @ballPlayer.body.velocity.x = 100
      #@ballPlayer.animations.play 'right'
      #  Scroll the background
      @bg.tilePosition.x -= 1

    else
      #  Stand still
      @ballPlayer.animations.stop()
      #@ballPlayer.frame = 4

    #  Generate further terrain
    @generateTerrain()

    @end()

  #  Active pointer down duration
  downTime: ->
    @downDuration = @moveButton.duration
    # Reset up duration
    @upDuration = 0

  #  Up duration, no pointer down
  upTime: ->
    @upDuration++
    #@timerTex.setText 'Time: ' + @upDuration
    # Reset down duration
    @downDuration = 0

  #   Play time
  updateTime: ->
    @time++
    @timerText.setText 'Time: ' + @time/10
    @Score()

  end: ->
    if @ballPlayer.body.y > @game.world.height - 30
      @state.start 'Menu'

  #  Generate further terrain
  generateTerrain: ->
    delta = 0
    i = 0
    while i < @floors.length
      if @floors.getAt(i).body.x <= -@tileSize
        if Math.random() < @probCliff && !@lastCliff && !@lastVertical
          delta = 1
          @lastCliff = true
          @lastVertical = false
        else if Math.random() < @probVertical && !@lastCliff
          @lastCliff = false
          @lastVertical = true
          block = @verticalObstacles.getFirstExists false
          block.reset @lastFloor.body.x + @tileSize, @game.world.height - (3 * @tileSize)
          block.body.velocity.x = @levelSpeed
          block.body.immovable = true
          if Math.random() < @probMoreVertical
            block = @verticalObstacles.getFirstExists false
            if block
              block.reset @lastFloor.body.x + @tileSize, @game.world.height - (4 * @tileSize)
              block.body.velocity.x = @levelSpeed
              block.body.immovable = true
              star = 0
              @star = @stars.create star * 70, 0, 'star'
              #  Let gravity do its thing
              @star.body.gravity.y = 400
              #  This just gives each star a slightly random bounce value
              @star.body.bounce.y = 0.5 + Math.random() * 0.2
              star++
        else
          @lastCliff = false
          @lastVertical = false
        @floors.getAt(i).body.x = @lastFloor.body.x + @tileSize + delta * @tileSize * 1.5
        @lastFloor = @floors.getAt(i)
        break
      i++
    return

  BallHit: ->
    return

  createCoins: ->
    @coins = @game.add.group()
    @coins.enableBody = true
    result = @findObjectsByType 'coin', @map, 'objectsLayer'
    result.forEach ((element) ->
      @createFromTiledObject element, @coins
      return
    ), @
    return

  collectStar: (ballPlayer, star) ->
    # Removes the star from the screen
    star.kill()
    #  Add and update the score
    score += 10
    @Score()

  Score: ->
    @scoreText.text = 'Score: ' + score
