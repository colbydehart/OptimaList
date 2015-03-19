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
