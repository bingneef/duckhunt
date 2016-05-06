angular.module 'App'
  .run ($rootScope, $log, $state, SocketService) ->
    'ngInject'
    $log.debug 'runBlock end'

    $rootScope.$on '$stateChangeSuccess', (event, toState, toParams, fromState, fromParams, options) ->
      if toState.name.indexOf('slave') == 0
        $rootScope.socketRole = 'slave'
      else
        $rootScope.socketRole = 'host'

      if !$rootScope.credentials? && toState.name.indexOf('login') == -1
        $state.go 'fs.login'


