(function() {
  'use strict';

  angular
    .module('k7')
    .controller('InterController', InterController);



  /** @ngInject */
  function InterController($http,$state,$stateParams,$timeout) {

    var vm = this;
    vm.stat = true;
    vm.cloc = $stateParams.cloc;
    vm.done = true;

    vm.datto = function() {
	vm.date = new Date();
    }

    vm.display = [];

    vm.get = function(cloc,rloc) {
	$state.go("gdel.internal.view2",{cloc: cloc,rloc: rloc});
    }
 
    vm.getava = function() { 
    vm.rloc = $stateParams.rloc;
	$http.get("/iot/del/"+$stateParams.cloc)
	.then(function(resp) {
		vm.showall = resp.data;
	});
    }
    vm.getava();

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

    vm.ini = function(scd,qtys) {
	vm.ston = scd;
	vm.qtyc = qtys;
	vm.qtyt = '';
	vm.trans = '';
	vm.getser();
    }

    vm.getser = function() {
        $http.get("/iot/conscd/"+vm.ston+"/"+$stateParams.cloc)
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

    vm.alltrans = [];

    vm.contra = function(qtyt) {
        for(var i=0;i<vm.showall.length;i++){
		if(vm.showall[i].scd == vm.ston){
			vm.showall[i].qtyt = qtyt;
			vm.showall[i].sta = false;
		}
	}
	$http.get("/iot/trans/"+qtyt+"/"+vm.ston+"/"+$stateParams.cloc)
	.then(function(resp) {
		vm.trans = resp.data;
		vm.alltrans.push.apply(vm.alltrans, vm.trans);
	});
    }


    vm.getdn = function() {
	$http.get("/iot/dn")
	.then(function(resp) {
		vm.dnh = resp.data;
		vm.tem = vm.dnh[0].dno;
		$timeout(vm.deliver(),1000);
	});
    }

    vm.del = {};

    vm.deliver = function() {
	vm.datto();
	vm.del.dno = vm.tem;
	vm.del.ddt = vm.date;
	vm.del.qty = vm.alltrans.length;
	vm.del.frm = $stateParams.cloc;
	for(var j=0; j<vm.alltrans.length;j++) {
		vm.del.scd = vm.alltrans[j].scd;
		vm.del.sno = vm.alltrans[j].sno;
		vm.del.loc = "Heading to " + $stateParams.rloc;
		$http.post("/iot/deliver/",angular.copy(vm.del))
		.then(function() {
			vm.log="Success";
		}, function() {
			alert("DELIVERY ERROR!");
		});
	}
	$http.post("/iot/dnrec/",vm.del)
	.then(function() {
		alert("ITEM DELIVERY REGISTERED");
		vm.done = false;
	}, function() {
		alert("DELIVERY ERROR!");
	});
    }

  }
})();
