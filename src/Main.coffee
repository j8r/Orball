window.onload = ->
  DeviceWidth = window.innerWidth
  DeviceHeight = window.innerHeight
  game = new Phaser.Game DeviceWidth, DeviceHeight, Phaser.AUTO, 'game'
  #	Add the States your game has.
  game.state.add 'Boot', OrballBoot
  game.state.add 'Preload', OrballPreload
  game.state.add 'Menu', OrballMenu
  game.state.add 'Game', OrballGame
  #	Now start the Boot state.
  game.state.start 'Boot'
