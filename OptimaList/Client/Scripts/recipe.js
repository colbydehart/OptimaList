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
    //GET LIST
    $scope.getList = function(){
        var newIng = {}
        recipeService.getOptimaList().then(function(list) {
            for (var ing in list.ingredients){
                mmts = [];
                var cur = list.ingredients[ing];
                if (cur.mass) mmts.push(cur.mass + ' oz');
                if (cur.volume) mmts.push(cur.volume + ' cups');
                if (cur.unit) mmts.push(cur.unit + ' units');
                newIng[ing] = mmts.join(',');
            }
            list.ingredients = newIng;
            $scope.groceryList = list;
        }, function(err) {
            console.log(err);
        });
    };

}]);
