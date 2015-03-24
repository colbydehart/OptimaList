angular.module('OptimaList')
.config(['$routeProvider', function($routeProvider) {
    $routeProvider
    .when('/recipes', {
        controller: 'RecipeController',
        templateUrl: '/Client/Views/recipes.html'
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
            printError('Not enough recipes in pool ' +
                       'try adding more recipes or ' +
                       'selecting fewer for the list');
            return;
        }
        $('#print').remove();
        var newIng = {};
        recipeService.getOptimaList(num).then(function(list) {
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
            }
            list.ingredients = newIng;
            $scope.groceryList = list;
            var print = $('<ul>').attr('id', 'print');
            for (var ing in newIng){
                print.append($('<li>').text(ing + ': ' + newIng[ing]));
            }
            $('html').append(print);
        }, function(err) {
            console.log(err);
        });
    };

    function printError(tx){
        $('body').prepend(
            $('<div>').addClass('alert alert-danger alert-dismissable').text(tx)
            .append('<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>')
        );
    }

}]);
