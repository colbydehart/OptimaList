angular.module('OptimaList')
.config(['$routeProvider',
   function ($routeProvider) {
    $routeProvider
    .when('/register', {
        controller: 'SignupController',
        templateUrl: '/Client/Views/signup.html'
    })
    .when('/login', {
        controller: 'LoginController',
        templateUrl: '/Client/Views/login.html'
    });
}])
/************************************************
                SIGNUP CONTROLLER
************************************************/
.controller('SignupController', ['$scope', '$location', 'authService', 
                         function($scope,   $location,   authService) {
    
    $scope.signup = function(){
        authService.register($scope.user).then(
            function(res){
                console.log(res);
            },
            function(err) {
                console.log(err);
                $scope.errors = [];
                ers = err.data.ModelState;
                for (var key in ers){
                    ers[key].forEach(function(el) {
                        $scope.errors.push(el);
                    })
                }
            }
        );
        $scope.user = {};
    };

}])
/************************************************
                LOGIN CONTROLLER
************************************************/
.controller('LoginController', ['$scope', '$location', 'authService', 
                         function($scope,   $location,   authService) {
    $scope.login = function(){
        authService.login($scope.loginData)
        .then(function(data){
            $location.path('recipes');
        }, function(err){

        });
    };
}])
/************************************************
               AUTH SERVICE
************************************************/
.factory('authService', ['$http', '$q', 'localStorageService',
                 function($http,   $q,   localStorageService){

    var base = '/api/Account/';
    var as = {};
    function _register(user){
        return $http.post(base + 'Register', user);
    }
    function _login(user){
        user.grant_type = 'password';
        var deferred = $q.defer()

        $.post('/Token', user)
        .then(function(data){
           localStorageService.set('auth', {
               token: data.access_token,
               name: user.username
           });
           deferred.resolve(data); 
        }, function(err){
           deferred.reject(err); 
           console.log(err);
        });

        return deferred.promise;
    }

    as.login = _login;
    as.register = _register;

    return as;
}]);
