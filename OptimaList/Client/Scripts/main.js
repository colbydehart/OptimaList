angular.module('OptimaList', ['restangular', 'ngRoute', 'LocalStorageModule'])
.config(   ['RestangularProvider', '$routeProvider', '$httpProvider',
   function (RestangularProvider,   $routeProvider,   $httpProvider) {
    
    $httpProvider.interceptors.push('authInterceptorFactory');

    RestangularProvider.setBaseUrl('/api');
    RestangularProvider.setRestangularFields({ id: "ID" });
    RestangularProvider.setRequestInterceptor(function(el, op){
        if(op === 'remove')
            return null;
        return el;
    });

    $routeProvider.when('/', {
        controller: 'HomeController',
        templateUrl: '/Client/Views/home.html'
    });
}])

/************************************************
                HOME CONTROLLER
************************************************/
.controller('HomeController', ['localStorageService', '$location', function (localStorageService, $location)  {
    var auth = localStorageService.get('auth');
    if (auth){
        $location.path('recipes')
    }

}])
/************************************************
                AUTH INTERCEPTOR
************************************************/
.factory('authInterceptorFactory', ['$location', '$q', 'localStorageService', 
                            function($location,   $q,   localStorageService){
    return {
        request: function(config){
            config.headers = config.headers || {};

            var authData = localStorageService.get('auth')

            if(authData)
                config.headers.Authorization = 'Bearer ' + authData.token;

            return config;
        },
        responseError: function(rejection){
            if(rejection.status == 401){
                $location.url('login');
            }
            return $q.reject(rejection);
        }
    }
}]);

