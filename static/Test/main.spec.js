describe("HomeController", function(){
    beforeEach(module('OptimaList'));

    var ctrl, scope;
    //inject comes from angular-mocks and lets us access
    //the angular injector
    beforeEach(inject(function($controller, $rootScope){
        scope = $rootScope.$new();
        ctrl = $controller(
            'HomeController', 
            {$scope: scope}
        );
        //Another method:
        // scope = $rootScope
        // ctrl = function(scope) {
        //     return $controller(
        //        'HomeController',
        //        {$scope: scope}
        //     );
        // }
  }));

  it("Should have messages", function(){
    expect(ctrl).to.exist()
    scope.messages.should.have.length(2);
  });

});
