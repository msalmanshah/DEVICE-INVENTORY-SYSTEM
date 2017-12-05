(function() {
  'use strict';

  angular
    .module('k7')
    .controller('InveController', InveController);



  /** @ngInject */
  function InveController($http,$state) {

    var vm = this;
    vm.stat = true;
    
    vm.display = [];
 
    vm.get = function() { 
    $http.get("/gdvc")
    .then(function(resp) {
	vm.showall = resp.data;
	vm.display = resp.data; 
    });
    }
    vm.get();

       

    vm.getall = function() {
        if(vm.stat == true){
	$http.get("/iot/getsta/"+vm.ston)
	.then(function(resp) {
		vm.showser = resp.data;
	});
	vm.stat = false;
	}
	else {
		vm.getser();
	}
    }

    vm.close = function() {
	vm.stat = true;
    }

    vm.ini = function(scd) {
	vm.ston = scd;
	vm.getser();
    }

    vm.getser = function() {
        $http.get("/iot/conscd/"+vm.ston)
        .then(function(resp) {
                vm.showser = resp.data;

        });
        vm.stat = true;
    }
    vm.getser();

    vm.getitem = function() {
	$http.get("/iot/item")
	.then(function(resp) {
		vm.items = resp.data;
		vm.holditem = resp.data;
	});
    }
    vm.getitem();

    vm.go = function() {
	$state.go("item");
    }

    vm.go2 = function() {
	$state.go("stock");
    }

  }
})();
