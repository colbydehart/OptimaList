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
    recipeService.allRecipes().then(function(recipes) {
        $scope.recipes = recipes;
        $scope.message = "Hi";
    }, function(err) {
        console.log('boo', err);
    });

    $scope.createRecipe = function(){
        recipeService.createRecipe($scope.newRecipe).then(function(){
            console.log("Yayy, recipe made");
        }, function(err) {
            console.log('Booo', err);
        });
        $scope.newRecipe = {};
   };
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
