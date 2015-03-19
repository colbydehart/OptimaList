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
