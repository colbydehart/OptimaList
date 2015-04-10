angular.module('OptimaList', ['restangular', 'ngRoute', 'LocalStorageModule'])
.run(['$rootScope', function($rootScope) {
    $rootScope.printError = function(tx){
        $('body').prepend(
            $('<div>').addClass('alert alert-danger alert-dismissable').text(tx)
            .append('<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>')
        );
    };
}])
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
    })
    .when('/about', {
        templateUrl: '/Client/Views/about.html'
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
                HEADER CONTROLLER
************************************************/
.controller('HeaderController', ['$rootScope', 'localStorageService', '$location', 
                         function($rootScope,   localStorageService,   $location) {
    $rootScope.logout = function(){
        $rootScope.auth = null;
        localStorageService.remove('auth');
        $location.path('/');
    };
}])
/************************************************
                AUTH INTERCEPTOR
************************************************/
.factory('authInterceptorFactory', ['$location', '$q', 'localStorageService', '$rootScope', 
                            function($location,   $q,   localStorageService,   $rootScope){
    return {
        request: function(config){
            config.headers = config.headers || {};

            var authData = localStorageService.get('auth')

            if(authData){
                config.headers.Authorization = 'Token ' + authData.token;
                $rootScope.auth = authData;
            }

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

