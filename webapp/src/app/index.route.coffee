angular.module 'App'
  .config ($stateProvider, $urlRouterProvider) ->
    'ngInject'
    $stateProvider
      .state 'slave',
        abstract: true
        views:
          'navigation':
            controller: 'NavigationController'
            templateUrl: 'app/navigation/navigation.html'
      .state 'slave.duckhunt',
        url: '/slave/duckhunt'
        views:
          '@':
            templateUrl: 'app/duckhunt/duckhunt_slave.html'
            controller: 'DuckhuntSlaveController'
            controllerAs: 'duckhunt_slave'
      .state 'fs',
        abstract: true

      .state 'fs.login',
        url: '/login'
        views:
          '@':
            templateUrl: 'app/login/login.html'
            controller: 'LoginController'
            controllerAs: 'login'

      .state 'app',
        abstract: true
        views:
          'navigation':
            controller: 'NavigationController'
            templateUrl: 'app/navigation/navigation.html'
      .state 'app.duckhunt',
        url: '/duckhunt'
        views:
          '@':
            templateUrl: 'app/duckhunt/duckhunt.html'
            controller: 'DuckhuntController'
            controllerAs: 'duckhunt'

    $urlRouterProvider.otherwise '/login'
