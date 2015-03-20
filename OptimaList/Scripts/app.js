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
.controller('HomeController', ['$scope', function ($scope)  {
    $scope.messages = ["Hello", "World"];
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

angular.module('OptimaList')
.directive('addForm', [function(){
    return {
        templateUrl: "/Client/Directives/addForm.html",
        restrict: 'E'
    };
}]);

angular.module('OptimaList')
.config(['$routeProvider', function($routeProvider) {
    $routeProvider
    .when('/recipes', {
        controller: 'RecipeController',
        templateUrl: '/Client/Views/recipes.html'
    });
}])
/************************************************
                RECIPE CONTROLLER
************************************************/
.controller('RecipeController', ['$scope', 'recipeService', function($scope, recipeService){
    $scope.newRecipe = {};
    $scope.showForm = false;
    getRecipes();

    //CREATE
    $scope.createRecipe = function(){
        recipeService.createRecipe($scope.newRecipe).then(function(){
            getRecipes();
        }, function(err) {
            console.log('Booo', err);
        });
        $scope.newRecipe = {};
    };
    //DELETE
    $scope.deleteRecipe = function(recipe){
        recipe.remove().then(function(){
            getRecipes();
        }, function(err){
            console.log("ERR ", err);
        }); 
    };
    ///GET RECIPES
    function getRecipes(){
        recipeService.allRecipes().then(function(recipes) {
            $scope.recipes = recipes;
        }, function(err) {
            console.log('boo', err);
        });
    }

}]);

angular.module('OptimaList')
.factory('recipeService', ['Restangular', function(Restangular){
    var recipeService = {};

    var _baseRecipes = Restangular.all('recipes');

    var _allRecipes = function(){
        return _baseRecipes.getList();
    };

    var _createRecipe = function(recipe){
        return _baseRecipes.post(recipe);
    };
    


    recipeService.allRecipes = _allRecipes;
    recipeService.createRecipe = _createRecipe;
    return recipeService;
}]);
