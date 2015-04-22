angular.module('OptimaList')
.factory('recipeService', ['Restangular', '$http', '$q', function(Restangular, $http, $q){
    var recipeService = {};

    var _baseRecipes = Restangular.all('recipes');

    var _allRecipes = function(){
        return _baseRecipes.getList();
    };

    var _createRecipe = function(rec, ings){
        return _baseRecipes.post({recipe: rec, ingredients: ings});
    };

    var _getRecipe = function(id){
        return _baseRecipes.get(id);
    };

    var _getOptimaList = function(num) {
        return _baseRecipes.get("List", {num: num});
    };

    
    recipeService.getOptimaList = _getOptimaList;
    recipeService.getRecipe = _getRecipe;
    recipeService.allRecipes = _allRecipes;
    recipeService.createRecipe = _createRecipe;
    return recipeService;
}]);
