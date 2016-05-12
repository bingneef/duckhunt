angular.module 'App'
  .run ($rootScope, $log, $state, SocketService, Authentication, localStorageService) ->
    'ngInject'

    Authentication.initiate()

    $rootScope.$on '$stateChangeSuccess', (event, toState, toParams, fromState, fromParams, options) ->
      if toState.name.indexOf('slave') == 0
        $rootScope.socketRole = 'slave'
      else
        $rootScope.socketRole = 'host'


