(function() {
  'use strict';

  angular
    .module('k7')
    .controller('DeliController', DeliController);
	
    

  /** @ngInject */
  function DeliController($state,$timeout,$http) {
    var vm = this;

    
  
    vm.ok = 0;
    vm.hol = {};
    vm.time = function() {
	vm.dts = new Date();
    }
 
    vm.dec = function() {
	vm.time();
	vm.hol.grn = vm.grn;
        vm.hol.vcd = vm.vcd;
	vm.hol.dts = vm.dts;
        $http.post("/iot/do/", vm.hol)
	.then(function() {
		vm.log = "DO Sent";
		$state.go("deli.exter.table",{don: vm.hol.grn});
	});
    }


    vm.change = function(value) {
		if(value == "External"){
			$state.go("gdel.external");
			vm.ok = 1;
	}
		else {
			$state.go("gdel.internal");
			vm.ok = 2;
	}
    }

    vm.change2 = function(val) {
		if(val == "table"){
			$state.go("deli.exter.table",{don: vm.hol.grn});
		}
		else {
			$state.go("deli.exter.range");
		}
    }

    

    vm.submit = function() {
	$http.post("/iot/submit/"+vm.col)
	.then(function() {
		alert("Device Registered");
	}, function() {	
		alert("ERROR!");
	});
    }

    vm.test = function() {
	$http.post("/iot/test/"+vm.cat.grn)
	.then(function() {
		alert("Yeay");
	}, function() {
		alert("Nope");
	});
    }

    vm.conf = function(nos) {
                vm.log = "get strg";
                $state.go("deli.inter.show",{dno: nos});
    }


  } 

})();	
