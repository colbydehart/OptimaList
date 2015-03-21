angular.module('OptimaList')
.directive('addForm', ['recipeService', function(recipeService){

    var _link = function(scope, el, attrs){
        scope.newRecipe = {};
        scope.ingredients = [{
            Name: "",
            Quantity:1,
            Measurement:"cups"
        }];

        //CREATE RECIPE
        scope.addRecipe = function(){
            scope.ingredients = scope.ingredients.slice(0,-1);
            recipeService.createRecipe(scope.newRecipe, scope.ingredients).then(function(data){
                return recipeService.allRecipes();
            }, console.log).then(function(data) {
                scope.recipes = data;
            }).catch(console.log);
            scope.newRecipe = {};
            scope.ingredients = [{
                Name: "",
                Quantity:1,
                Measurement:"cups"
            }];
            scope.showForm = false;
        };

        scope.$watch('ingredients', function(value){
            var len = value.length;
            if(value[len-1].Name != ""){
                value.push({
                    Name: "",
                    Quantity:1,
                    Measurement:"cups"
                });
            }
            else if(value[len-1].Name === "" &&
                    value[len-2] && 
                    value[len-2].Name ===""){
                value.pop();
            }
        }, true);

    };

    return {
        templateUrl: "/Client/Directives/addForm.html",
        restrict: 'E',
        link : _link
    };
}]);
