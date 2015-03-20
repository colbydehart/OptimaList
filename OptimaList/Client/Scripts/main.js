angular.module('OptimaList', ['restangular', 'ngRoute', 'LocalStorageModule'])
.config(   ['RestangularProvider', '$routeProvider', '$httpProvider',
   function (RestangularProvider,   $routeProvider,   $httpProvider) {
    
    $httpProvider.interceptors.push('authInterceptorFactory');

    RestangularProvider.setBaseUrl('/api');

    $routeProvider.when('/', {
        controller: 'HomeController',
        templateUrl: '/Client/Views/home.html'
    });
}])

/************************************************
                HOME CONTROLLER
************************************************/
.controller('HomeController', ['$scope', function ($scope)  {
    $scope.messages = ["Hello", "World"];
}])
.factory('authInterceptorFactory', ['$location', '$q', 'localStorageService', 
                            function($location,   $q,   localStorageService){
    return {
        request: function(config){
            config.headers = config.headers || {};
            console.log(config);

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

