angular.module('OptimaList')
.config(['$routeProvider', function($routeProvider) {
    $routeProvider
    .when('/recipes/:id', {
        controller: 'DetailsController',
        templateUrl: '/Client/Views/detail.html'
    });
}])
.controller('DetailsController', ['$scope', 'recipeService', '$routeParams', 
                          function($scope,   recipeService,   $routeParams){
    var id = $routeParams.id;
    recipeService.getRecipe(id).then(function(recipe) {
        $scope.recipe = recipe;
    });
}]);
