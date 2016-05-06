angular.module 'App'
  .controller 'DuckhuntSlaveController', ($rootScope, $scope, $state, $window, $timeout, $interval, SocketService, SweetAlert, socketCredentials) ->
    'ngInject'

    return unless $rootScope.credentials
    room = "#{$rootScope.credentials.email}::#{$rootScope.credentials.pin}"
    SocketService.initiate(socketCredentials, room)

    $scope.status = {}
    activeLevel = 'duckhunt'
    $scope.state = 'loaded'

    $scope.$watch 'orientation', (newValue, oldValue) ->
      return unless $scope.state == 'ingame'
      payload =
        level: activeLevel
        destination: 'host'
        kind: 'orientation'
        value: newValue

      SocketService.socketTransmit payload
    , true

    $scope.readyClick = ->
      payload =
        level: activeLevel
        destination: 'host'
        kind: 'ready'

      SocketService.socketTransmit payload
      $scope.state = 'countdown'


    $scope.fireClick = ->
      payload =
        level: activeLevel
        destination: 'host'
        kind: 'fire'

      SocketService.socketTransmit payload

    $window.ondeviceorientation = (event) ->
      # $scope.drawingTimeout = $timeout ->
      $scope.orientation =
        alpha: 2 * Math.PI * event.alpha / 360
        beta: 2 * Math.PI * event.beta / 360
        gamma: 2 * Math.PI * event.gamma / 360

      $scope.$apply()

    $rootScope.$on 'socketTransmit', (event, data) ->
      return unless data.level == activeLevel
      switch data.kind
        when 'countdown'
          $scope.countdown = data.value
          $scope.$apply()
        when 'start'
          $scope.state = 'ingame'

    return
