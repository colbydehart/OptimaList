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
        var usr= $scope.user;
        authService.register(usr).then(
            function(res){
                authService.login({username:usr.Email, password:usr.Password}).then(function(){
                    $location.path('recipes');
                },
                function(err){
                    $scope.printError(err);
                });
            },
            function(err) {
                err = err.data.ModelState;
                for (var m in err){
                    _.forEach(err[m], function(el){
                        $scope.printError(el);
                    });
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
            $scope.printError(err.responseJSON.error_description);
        });
    };
}])
/************************************************
               AUTH SERVICE
************************************************/
.factory('authService', ['$http', '$q', 'localStorageService', '$rootScope',
                 function($http,   $q,   localStorageService,   $rootScope){

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
           $rootScope.auth = localStorageService.get('auth');
           deferred.resolve(data); 
        }, function(err){
           deferred.reject(err); 
        });

        return deferred.promise;
    }

    as.login = _login;
    as.register = _register;

    return as;
}]);
