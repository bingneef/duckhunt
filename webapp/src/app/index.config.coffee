angular.module 'App'
  .config ($logProvider, $httpProvider, localStorageServiceProvider, $authProvider) ->
    'ngInject'
    # Enable log
    $logProvider.debugEnabled true
    # Set options third-party lib
    $httpProvider.interceptors.push('AuthenticationInterceptor')
    localStorageServiceProvider.setPrefix('Riddle')

    $authProvider.google({
      clientId: '856409384233-qc71plh2ghd67boib516ud2ia6jp68b6.apps.googleusercontent.com'
      redirectUri: 'http://localhost:5000/oauth/callback?provider=google'
      requiredUrlParams: ['scope']
      scope: ['profile', 'email']
    })

    $authProvider.facebook({
      clientId: '1707544686127506'
      redirectUri: 'http://localhost:5000/oauth/callback?provider=facebook'
    })





