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
.factory('authInterceptorFactory', ['$location', '$q', function($location, $q){
    return {
        responseError: function(rejection){
            if(rejection.status == 401){
                $location.url('login');
            }
            return $q.reject(rejection);
        }
    }
}]);

