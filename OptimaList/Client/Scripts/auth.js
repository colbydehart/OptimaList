angular.module('OptimaList')
/************************************************
                SIGNUP CONTROLLER
************************************************/
.controller('SignupController', ['$scope', '$location', 'authService', 
                         function($scope,   $location,   authService) {
    

}])
/************************************************
                LOGIN CONTROLLER
************************************************/
.controller('LoginController', ['$scope', '$location', 'authService', 
                         function($scope,   $location,   authService) {
}])
/************************************************
               AUTH SERVICE
************************************************/
.factory('authService', ['$http', '$q', 'localStorageService',
                 function($http,   $q,   localStorageService){
}]);
