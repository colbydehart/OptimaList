angular.module('OptimaList')
.directive('groceryList', ['recipeService', function(recipeService){
    var _link = function(scope, el, attrs){
    	scope.print = function(){
    		window.print();
    	};
        
    };

    return {
        templateUrl: "/Client/Directives/list.html",
        restrict: 'E',
        link : _link
    };
}]);
