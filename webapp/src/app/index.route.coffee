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
        url: '/duckhunt/slave'
        views:
          '@':
            templateUrl: 'app/duckhunt/duckhunt_slave.html'
            controller: 'DuckhuntSlaveController'
            controllerAs: 'duckhunt_slave'
      .state 'splash',
        url: '/'
        views:
          '@':
            templateUrl: 'app/splash/splash.html'
            controller: 'SplashController'
            controllerAs: 'Splash'

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

    $urlRouterProvider.otherwise '/'
