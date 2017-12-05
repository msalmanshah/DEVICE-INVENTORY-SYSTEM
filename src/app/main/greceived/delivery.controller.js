(function() {
  'use strict';

  angular
    .module('k7')
    .controller('DeliveryController', DeliveryController);
	
    

  /** @ngInject */
  function DeliveryController($state,$timeout,$http) {
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
        vm.hol.loc = vm.loct;
        $http.post("/iot/do/", vm.hol)
	.then(function() {
		vm.log = "DO Sent";
		$state.go("deli.exter.table",{don: vm.hol.grn});
	});
    }

    vm.gloct = function() {
        $http.get("/iot/loct")
        .then(function(resp) {
            vm.loca = resp.data;
        });
    }
    vm.gloct();

    vm.change = function(value) {
		if(value == "External"){
			$state.go("deli.exter");
			vm.ok = 1;
	}
		else {
			$state.go("deli.inter");
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
