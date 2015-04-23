angular.module('OptimaList')
.directive('groceryList', ['recipeService', '$q', 'localStorageService', function(recipeService, $q, localStorageService){
    var _link = function(scope, el, attrs){
    	scope.print = function(){
    		window.print();
    	};

    	scope.mail = function(){
			var emailTo = localStorageService.get('auth').name;
			var emailBody = '';
			$('#print li').each(function() {emailBody+= $(this).text() + '\n'});
			window.location.href = 'mailto:'+emailTo+'?Subject=OptimaList&Body='+escape(emailBody);
        };

        scope.removeRecipes = function(){
            var proms = [];
            _.each(scope.groceryList.recipes, function(el){
                proms.push( 
                    _.find(scope.recipes, {id: el.id}).remove()
                );
            });
            $q.all(proms)
                .then(recipeService.allRecipes)
                .then(function(rs){scope.recipes = rs;});
        };
    };

    return {
        templateUrl: "/static/ol/directives/list.html",
        restrict: 'E',
        link : _link
    };
}]);
