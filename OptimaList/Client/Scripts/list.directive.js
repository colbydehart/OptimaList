angular.module('OptimaList')
.directive('groceryList', ['recipeService', 'localStorageService', function(recipeService, localStorageService){
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
    };

    return {
        templateUrl: "/Client/Directives/list.html",
        restrict: 'E',
        link : _link
    };
}]);
