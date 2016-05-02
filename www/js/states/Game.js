// Generated by CoffeeScript 1.10.0
var OrballGame;

OrballGame = function() {
  var newItem, score;
  score = 0;
  newItem = void 0;
  return {
    create: function() {
      var i, star;
      this.game.physics.startSystem(Phaser.Physics.ARCADE);
      this.stage.backgroundColor = '#5555AA';
      this.bg = this.game.add.tileSprite(0, 510, this.game.world.width, this.game.world.height, 'bg');
      this.levelSpeed = -250;
      this.tileSize = 70;
      this.probCliff = 0.4;
      this.probVertical = 0.4;
      this.probMoreVertical = 0.5;
      this.friction = 0.6;
      this.floors = this.game.add.group();
      this.floors.enableBody = true;
      this.lastFloor = newItem;
      this.lastCliff = false;
      this.lastVertical = false;
      this.verticalObstacles = this.game.add.group();
      this.verticalObstacles.enableBody = true;
      this.verticalObstacles.createMultiple(12, 'yellowBlock');
      this.verticalObstacles.setAll('checkWorldBounds', true);
      this.verticalObstacles.setAll('outOfBoundsKill', true);
      i = 0;
      while (i < this.game.world.width / 80) {
        newItem = this.floors.create(i * this.tileSize, this.game.world.height - this.tileSize, 'floor');
        newItem.body.immovable = true;
        newItem.body.velocity.x = this.levelSpeed;
        i++;
      }
      this.coins = this.game.add.group();
      this.coins.enableBody = true;
      this.lastFloor = newItem;
      this.ballPlayer = this.game.add.sprite(32, this.game.world.height - 150, 'ball');
      this.game.physics.arcade.enable(this.ballPlayer);
      this.game.camera.follow(this.ballPlayer);
      this.ballPlayer.body.gravity.y = 400;
      this.ballPlayer.body.collideWorldBounds = true;
      this.ballPlayer.anchor.setTo(0.5, 1);
      this.stars = this.game.add.group();
      this.stars.enableBody = true;
      star = 0;
      while (star < 3) {
        this.star = this.stars.create(star * 70, 0, 'star');
        this.star.body.gravity.y = 400;
        this.star.body.bounce.y = 0.5 + Math.random() * 0.2;
        star++;
      }
      this.scoreText = this.game.add.text(16, 16, 'Score: 0', {
        fontSize: '32px',
        fill: '#ADD'
      });
      this.cursors = this.game.input.keyboard.createCursorKeys();
      this.moveButton = this.game.input.activePointer;
      this.game.input.onUp.add(this.downTime, this);
      this.game.input.onDown.add(this.upTime, this);
      this.time = 0;
      this.upDuration = 0;
      this.timerText = this.game.add.text(15, 50, "Time: " + this.time, this.fontBig);
      this.game.time.events.loop(Phaser.Timer.SECOND * 0.1, this.updateTime, this);
      this.game.time.events.loop(Phaser.Timer.SECOND * 0.1, this.upTime, this);
    },
    update: function() {
      var ref, ref1;
      this.game.physics.arcade.collide(this.ballPlayer, this.floors);
      this.game.physics.arcade.collide(this.stars, this.floors);
      this.game.physics.arcade.collide(this.ballPlayer, this.verticalObstacles, this.playerHit, null, this);
      this.game.physics.arcade.overlap(this.ballPlayer, this.stars, this.collectStar, null, this);
      this.bg.tilePosition.x += this.levelSpeed / 100;
      this.ballPlayer.body.velocity.x = this.ballPlayer.body.velocity.x / 2;
      if (this.ballPlayer.body.touching.down) {
        this.ballPlayer.body.velocity.x = (this.ballPlayer.body.velocity.x - this.levelSpeed) / 2;
      }
      if ((this.moveButton.isDown && (0 < (ref = this.upDuration) && ref < 3) || (0 < (ref1 = this.downDuration) && ref1 < 400)) && this.ballPlayer.body.touching.down) {
        this.ballPlayer.body.velocity.y = -300;
      } else if (this.moveButton.isDown && this.ballPlayer.body.touching.down) {
        this.ballPlayer.body.velocity.x = 100 - this.levelSpeed;
      } else if (this.moveButton.isDown) {
        this.ballPlayer.body.velocity.x = 100;
        this.bg.tilePosition.x -= 1;
      } else {
        this.ballPlayer.animations.stop();
      }
      this.generateTerrain();
      return this.end();
    },
    downTime: function() {
      this.downDuration = this.moveButton.duration;
      return this.upDuration = 0;
    },
    upTime: function() {
      this.upDuration++;
      return this.downDuration = 0;
    },
    updateTime: function() {
      this.time++;
      this.timerText.setText('Time: ' + this.time / 10);
      return this.Score();
    },
    end: function() {
      if (this.ballPlayer.body.y > this.game.world.height - 30) {
        return this.state.start('Menu');
      }
    },
    generateTerrain: function() {
      var block, delta, i, star;
      delta = 0;
      i = 0;
      while (i < this.floors.length) {
        if (this.floors.getAt(i).body.x <= -this.tileSize) {
          if (Math.random() < this.probCliff && !this.lastCliff && !this.lastVertical) {
            delta = 1;
            this.lastCliff = true;
            this.lastVertical = false;
          } else if (Math.random() < this.probVertical && !this.lastCliff) {
            this.lastCliff = false;
            this.lastVertical = true;
            block = this.verticalObstacles.getFirstExists(false);
            block.reset(this.lastFloor.body.x + this.tileSize, this.game.world.height - (3 * this.tileSize));
            block.body.velocity.x = this.levelSpeed;
            block.body.immovable = true;
            if (Math.random() < this.probMoreVertical) {
              block = this.verticalObstacles.getFirstExists(false);
              if (block) {
                block.reset(this.lastFloor.body.x + this.tileSize, this.game.world.height - (4 * this.tileSize));
                block.body.velocity.x = this.levelSpeed;
                block.body.immovable = true;
                star = 0;
                this.star = this.stars.create(star * 70, 0, 'star');
                this.star.body.gravity.y = 400;
                this.star.body.bounce.y = 0.5 + Math.random() * 0.2;
                star++;
              }
            }
          } else {
            this.lastCliff = false;
            this.lastVertical = false;
          }
          this.floors.getAt(i).body.x = this.lastFloor.body.x + this.tileSize + delta * this.tileSize * 1.5;
          this.lastFloor = this.floors.getAt(i);
          break;
        }
        i++;
      }
    },
    BallHit: function() {},
    createCoins: function() {
      var result;
      this.coins = this.game.add.group();
      this.coins.enableBody = true;
      result = this.findObjectsByType('coin', this.map, 'objectsLayer');
      result.forEach((function(element) {
        this.createFromTiledObject(element, this.coins);
      }), this);
    },
    collectStar: function(ballPlayer, star) {
      star.kill();
      score += 10;
      return this.Score();
    },
    Score: function() {
      return this.scoreText.text = 'Score: ' + score;
    }
  };
};