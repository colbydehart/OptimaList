angular.module('OptimaList')
.config(['$routeProvider', function($routeProvider) {
    $routeProvider
    .when('/recipes', {
        controller: 'RecipeController',
        templateUrl: '/static/ol/views/recipes.html'
    });
}])
/***********************************************
                RECIPE CONTROLLER
************************************************/
.controller('RecipeController', ['$scope', 'recipeService', function($scope, recipeService){
    $scope.newRecipe = {};
    $scope.num = 4;
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
    $scope.getList = function(num){
        if (num > $scope.recipes.length){
            $scope.printError('Not enough recipes in pool ' +
                       'try adding more recipes or ' +
                       'selecting fewer for the list');
            return;
        }
        $('#print').remove();
        var print = $('<ul>').attr('id', 'print');
        var newIng = {};
        recipeService.getOptimaList(num).then(function(list) {
            print.append($('<h3>').text('Recipes'));
            _.each(list.recipes, function(el){
                print.append($('<li>').text(el.Name + ': ' + el.Url));
            });
            print.append($('<h3>').text('Ingredients'));
            for (var ing in list.ingredients){
                var mmts = [];
                var cur = list.ingredients[ing];
                if (cur.mass) mmts.push(cur.mass + ' oz');
                if (cur.volume){
                    var str = cur.volume >= 1 ?
                        cur.volume + ' cups' :
                        (cur.volume*16) + ' tbsp';
                    mmts.push(str);
                }
                if (cur.unit) mmts.push(cur.unit + ' units');
                newIng[ing] = mmts.join(' + ');
                print.append($('<li>').text(ing + ': ' + newIng[ing]));
            }
            list.ingredients = newIng;
            $scope.groceryList = list;
            $('html').append(print);
        }, function(err) {
            document.write(err.data);
        });
    };

}]);
