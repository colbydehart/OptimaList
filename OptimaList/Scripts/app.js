angular.module('OptimaList', ['restangular', 'ngRoute', 'LocalStorageModule'])
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
/************************************************
                AUTH INTERCEPTOR
************************************************/
.factory('authInterceptorFactory', ['$location', '$q', 'localStorageService', 
                            function($location,   $q,   localStorageService){
    return {
        request: function(config){
            config.headers = config.headers || {};

            var authData = localStorageService.get('auth')

            if(authData)
                config.headers.Authorization = 'Bearer ' + authData.token;

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
                console.log(err);
                $scope.errors = [];
                ers = err.data.ModelState;
                for (var key in ers){
                    ers[key].forEach(function(el) {
                        $scope.errors.push(el);
                    })
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

        });
    };
}])
/************************************************
               AUTH SERVICE
************************************************/
.factory('authService', ['$http', '$q', 'localStorageService',
                 function($http,   $q,   localStorageService){

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
           deferred.resolve(data); 
        }, function(err){
           deferred.reject(err); 
           console.log(err);
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
.directive('groceryList', ['recipeService', function(recipeService){
    var _link = function(scope, el, attrs){

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
        scope.ingredients = [{
            Name: "",
            Quantity:1,
            Measurement:"none"
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
                Measurement:"none"
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

angular.module('OptimaList')
.config(['$routeProvider', function($routeProvider) {
    $routeProvider
    .when('/recipes', {
        controller: 'RecipeController',
        templateUrl: '/Client/Views/recipes.html'
    });
}])
/************************************************
                RECIPE CONTROLLER
************************************************/
.controller('RecipeController', ['$scope', 'recipeService', function($scope, recipeService){
    $scope.newRecipe = {};
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
    $scope.getList = function(){
        var newIng = {}
        recipeService.getOptimaList().then(function(list) {
            for (var ing in list.ingredients){
                mmts = [];
                var cur = list.ingredients[ing];
                if (cur.mass) mmts.push(cur.mass + ' oz');
                if (cur.volume) mmts.push(cur.volume + ' cups');
                if (cur.unit) mmts.push(cur.unit + ' units');
                newIng[ing] = mmts.join(',');
            }
            list.ingredients = newIng;
            $scope.groceryList = list;
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

    var _getOptimaList = function() {
        return _baseRecipes.get("List");
    };

    
    recipeService.getOptimaList = _getOptimaList;
    recipeService.getRecipe = _getRecipe;
    recipeService.allRecipes = _allRecipes;
    recipeService.createRecipe = _createRecipe;
    return recipeService;
}]);
