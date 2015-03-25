angular.module('OptimaList', ['restangular', 'ngRoute', 'LocalStorageModule'])
.run(['$rootScope', function($rootScope) {
    $rootScope.printError = function(tx){
        $('body').prepend(
            $('<div>').addClass('alert alert-danger alert-dismissable').text(tx)
            .append('<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>')
        );
    };
}])
.config(   ['RestangularProvider', '$routeProvider', '$httpProvider',
   function (RestangularProvider,   $routeProvider,   $httpProvider) {
    
    $httpProvider.interceptors.push('authInterceptorFactory');

    RestangularProvider.setBaseUrl('/api');
    RestangularProvider.setRestangularFields({ id: "ID" });
    RestangularProvider.setRequestInterceptor(function(el, op){
        if(op === 'remove')
            return null;
        return el;
    });

    $routeProvider.when('/', {
        controller: 'HomeController',
        templateUrl: '/Client/Views/home.html'
    });
}])

/************************************************
                HOME CONTROLLER
************************************************/
.controller('HomeController', ['localStorageService', '$location', function (localStorageService, $location)  {
    var auth = localStorageService.get('auth');
    if (auth){
        $location.path('recipes')
    }

}])
.controller('HeaderController', ['$rootScope', 'localStorageService', '$location', 
                         function($rootScope,   localStorageService,   $location) {
    $rootScope.logout = function(){
        $rootScope.auth = null;
        localStorageService.remove('auth');
        $location.path('/');
    };
}])
/************************************************
                AUTH INTERCEPTOR
************************************************/
.factory('authInterceptorFactory', ['$location', '$q', 'localStorageService', '$rootScope', 
                            function($location,   $q,   localStorageService,   $rootScope){
    return {
        request: function(config){
            config.headers = config.headers || {};

            var authData = localStorageService.get('auth')

            if(authData){
                config.headers.Authorization = 'Bearer ' + authData.token;
                $rootScope.auth = authData;
            }

            return config;
        },
        responseError: function(rejection){
            if(rejection.status == 401){
                $location.url('login');
            }
            return $q.reject(rejection);
        }
    }
}]);


angular.module('OptimaList')
.config(['$routeProvider',
   function ($routeProvider) {
    $routeProvider
    .when('/register', {
        controller: 'SignupController',
        templateUrl: '/Client/Views/signup.html'
    })
    .when('/login', {
        controller: 'LoginController',
        templateUrl: '/Client/Views/login.html'
    });
}])
/************************************************
                SIGNUP CONTROLLER
************************************************/
.controller('SignupController', ['$scope', '$location', 'authService', 
                         function($scope,   $location,   authService) {
    
    $scope.signup = function(){
        authService.register($scope.user).then(
            function(res){
                console.log(res);
            },
            function(err) {
                err = err.data.ModelState;
                for (var m in err){
                    _.forEach(err[m], function(el){
                        $scope.printError(el);
                    });
                }
            }
        );
        $scope.user = {};
    };

}])
/************************************************
                LOGIN CONTROLLER
************************************************/
.controller('LoginController', ['$scope', '$location', 'authService', 
                         function($scope,   $location,   authService) {
    $scope.login = function(){
        authService.login($scope.loginData)
        .then(function(data){
            $location.path('recipes');
        }, function(err){
            $scope.printError(err.responseJSON.error_description);
        });
    };
}])
/************************************************
               AUTH SERVICE
************************************************/
.factory('authService', ['$http', '$q', 'localStorageService', '$rootScope',
                 function($http,   $q,   localStorageService,   $rootScope){

    var base = '/api/Account/';
    var as = {};
    function _register(user){
        return $http.post(base + 'Register', user);
    }
    function _login(user){
        user.grant_type = 'password';
        var deferred = $q.defer()

        $.post('/Token', user)
        .then(function(data){
           localStorageService.set('auth', {
               token: data.access_token,
               name: user.username
           });
           $rootScope.auth = localStorageService.get('auth');
           deferred.resolve(data); 
        }, function(err){
           deferred.reject(err); 
        });

        return deferred.promise;
    }

    as.login = _login;
    as.register = _register;

    return as;
}]);

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
                    _.find(scope.recipes, {ID: el.ID}).remove()
                );
            });
            $q.all(proms)
                .then(recipeService.allRecipes)
                .then(function(rs){scope.recipes = rs;});
        };
    };

    return {
        templateUrl: "/Client/Directives/list.html",
        restrict: 'E',
        link : _link
    };
}]);

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
            Name: "",
            Quantity:1,
            Measurement:scope.units[0]
        }];

        //CREATE RECIPE
        scope.addRecipe = function(){
            scope.ingredients = scope.ingredients.slice(0,-1);
            scope.ingredients = scope.ingredients.map(function(el) {
                el.Measurement = el.Measurement.value;
                return el;
            });
            recipeService.createRecipe(scope.newRecipe, scope.ingredients).then(function(data){
                return recipeService.allRecipes();
            }, console.log).then(function(data) {
                scope.recipes = data;
            }).catch(console.log);
            scope.newRecipe = {};
            scope.ingredients = [{
                Name: "",
                Quantity:1,
                Measurement:scope.units[0]
            }];
            scope.showForm = false;
        };

        scope.$watch('ingredients', function(value){
            var len = value.length;
            if(value[len-1].Name != ""){
                value.push({
                    Name: "",
                    Quantity:1,
                    Measurement:scope.units[0]
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
            $scope.printError('Not enough recipes in pool ' +
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

}]);

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
