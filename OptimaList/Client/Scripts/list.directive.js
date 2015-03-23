angular.module('OptimaList')
.directive('groceryList', ['recipeService', function(recipeService){
    var _link = function(scope, el, attrs){

    };

    return {
        templateUrl: "/Client/Directives/list.html",
        restrict: 'E',
        link : _link
    };
}]);
