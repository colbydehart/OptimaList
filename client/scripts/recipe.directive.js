angular.module('OptimaList')
.directive('addForm', ['recipeService', function(recipeService){

    var _link = function(scope, el, attrs){
        scope.newRecipe = {};
        var units = 'none,cup,tbsp,tsp,mL,L,pint,quart,gallon,floz,lb,oz,kg,g'.split(',');
        units = _.zip(units, ',cups,tbsp,tsp,mL,L,pint,quart,gallon,fl. oz,lb,oz,kg,g'.split(','));
        scope.units = units.map(function(el) {
           return {label:el[1], value:el[0]} ;
        });
        scope.ingredients = [{
            name: "",
            quantity:1,
            measurement:scope.units[0]
        }];

        //CREATE RECIPE
        scope.addRecipe = function(){
            scope.fadd.$setPristine();
            scope.ingredients = scope.ingredients.slice(0,-1);
            scope.ingredients = scope.ingredients.map(function(el) {
                el.measurement = el.measurement.value;
                return el;
            });
            recipeService.createRecipe(scope.newRecipe, scope.ingredients).then(function(data){
                return recipeService.allRecipes();
            }, function(err){document.write(err.data)}).then(function(data) {
                scope.recipes = data;
            }, function(err){document.write(err.data)});
            scope.newRecipe = {};
            scope.ingredients = [{
                name: "",
                quantity:1,
                measurement:scope.units[0]
            }];
            scope.showForm = false;
        };

        scope.$watch('ingredients', function(value){
            var len = value.length;
            if(value[len-1].name != ""){
                value.push({
                    name: "",
                    quantity:1,
                    measurement:scope.units[0]
                });
            }
            else if(value[len-1].name === "" &&
                    value[len-2] && 
                    value[len-2].name ===""){
                value.pop();
            }
        }, true);

    };

    return {
        templateUrl: "/static/ol/directives/addForm.html",
        restrict: 'E',
        link : _link
    };
}]);
