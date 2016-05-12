angular.module 'App'
  .controller 'DuckhuntController', ($rootScope, $scope, $state, $window, $timeout, $interval, SocketService, socketCredentials) ->
    'ngInject'

    return unless $rootScope.shallowCredentials
    room = "#{$rootScope.shallowCredentials.email}::#{$rootScope.shallowCredentials.pin}"
    SocketService.initiate(socketCredentials, room)

    $scope.status = {}
    activeLevel = 'duckhunt'
    $scope.code = ''
    $scope.hits = 0
    $scope.hitsForLevel = 20
    $scope.countdown = 5
    $scope.state = 'loaded'

    renderer = PIXI.autoDetectRenderer($window.innerWidth, $window.innerHeight, backgroundColor: 0x1fc8db)
    center =
      y: $window.innerHeight / 2
      x: $window.innerWidth / 2

    # do some form of countdown
    ready = ->
      $scope.state = 'countdown'
      console.log $scope.state
      payload =
          level: activeLevel
          destination: 'slave'
          kind: 'countdown'
          value: $scope.countdown

        SocketService.socketTransmit payload

      $interval ->
        $scope.countdown--
        payload =
          level: activeLevel
          destination: 'slave'
          kind: 'countdown'
          value: $scope.countdown

        SocketService.socketTransmit payload
        startGame() unless $scope.countdown > 0
      , 1000, 5

    startGame = ->
      $scope.state = 'ingame'
      $scope.gameStarted = true
      $scope.timerElement = document.getElementById("duckhunt").getElementsByTagName('timer')[0]
      $scope.timerElement.start()

      payload =
        level: activeLevel
        destination: 'slave'
        kind: 'start'

      SocketService.socketTransmit payload

    animate = ->
      requestAnimationFrame animate
      if $scope.crossEye?
        crossEye.position.x = center.x + $scope.crossEye.horizontal
        crossEye.position.y = center.y + $scope.crossEye.vertical
      # render the container
      renderer.render stage
      return

    defineCrossEye = ->
      return unless $scope.orientation?

      multiplication = 600
      $scope.crossEye =
        vertical: -Math.tan($scope.orientation.beta) * multiplication
        horizontal: -Math.tan($scope.orientation.alpha) * multiplication

    repositionTarget = ->
      target.position =
        x: Math.random() * $window.innerWidth
        y: Math.random() * $window.innerHeight

    document.body.appendChild renderer.view
    stage = new (PIXI.Container)

    # target
    texture = PIXI.Texture.fromImage("assets/images/gulp.png")
    target = new (PIXI.Sprite)(texture)
    target.anchor.x = 0.5
    target.anchor.y = 0.5
    target.position = angular.copy center
    stage.addChild target

    # crossEye
    texture = PIXI.Texture.fromImage("assets/images/angular.png")
    crossEye = new (PIXI.Sprite)(texture)
    crossEye.anchor.x = 0.5
    crossEye.anchor.y = 0.5
    crossEye.position = angular.copy center
    stage.addChild crossEye

    # start animating
    animate()


    validateFire = ->
      return if Math.abs(target.position.y - crossEye.position.y) > target.height
      return if Math.abs(target.position.x - crossEye.position.x) > target.width
      # defineTarget()
      $scope.hits++
      repositionTarget()
      $scope.$apply()
      unless $scope.hits < $scope.hitsForLevel
        alert 'completed'
        $scope.timerElement.stop()

    $rootScope.$on 'socketTransmit', (event, data) ->
      return unless data.level == activeLevel
      switch data.kind
        when 'orientation'
          $scope.orientation = data.value
          defineCrossEye()
        when 'fire'
          return unless $scope.gameStarted
          validateFire()
        when 'ready'
          return if $scope.gameStarted
          ready()
          $scope.$apply()

