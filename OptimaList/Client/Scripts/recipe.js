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
