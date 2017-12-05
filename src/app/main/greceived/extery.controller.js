(function() {
  'use strict';

  angular
    .module('k7')
    .controller('ExteryController', ExteryController);



  /** @ngInject */
  function ExteryController($state,$timeout,$http,$stateParams) {
    var vm = this;

    vm.don = $stateParams.don;
    vm.item = [];
    vm.dno = $stateParams.dno;
 
    vm.time = function() {
	vm.rdt = new Date();
    }

//	TO ADD STOCK DETAILS
    vm.add = function(){
	vm.sto = vm.sto.toUpperCase();
	vm.stat = true;
	vm.item.push({'sto':vm.sto,'qty':vm.qty,'sta':vm.stat});
	$http.post("/iot/sto/"+vm.sto+"/"+vm.qty+"/"+vm.don)
	.then(function(){
		vm.log="sent";
                vm.sto = '';
		vm.qty = '';
	}, function() {
		alert("ERROR!");
	});
    }

    vm.sern = [];
    vm.col = {};

    vm.grec = function() {
       vm.loct = vm.loct;
       $http.post("/iot/grec/"+vm.dno+"/"+vm.loct)
      .then(function() { },function() {});
    }

//      GET INTERNAL (ggdel)
    vm.getdel = function() {
       $http.get("/iot/ggdel/"+vm.dno)
       .then(function(resp) {
              vm.ggdel = resp.data;
       });
    }
    vm.getdel();

    vm.loct = function() {
        $http.get("/iot/loct")
        .then(function(resp) {
               vm.loca = resp.data;
        });
    }
    vm.loct();

//	TO GET THE SELECTED STOCK ID 
    vm.ini = function(sto,qtyi){
	vm.ston = sto;
	vm.sqty	= qtyi;
	vm.getser();
    }    

//	ADD SERIAL NO TO THE LIST
    vm.addSer = function() {
	vm.ser = vm.ser.toUpperCase();
	vm.alser = vm.ser.match(/[a-z]+/ig);
	vm.numser = vm.ser.match(/\d+/);
	if(vm.alser == null || vm.numser == null){
		alert("Serial NO Invalid");
	}
	else {
		vm.numser = ("00000"+vm.numser).slice(-5);
		vm.ser = vm.alser + vm.numser.toString();
		vm.sern.push({'ser':vm.ser});
	}
	vm.ser = '';
    }

//	INPUT THE DATA FROM LIST INTO DATABASE
    vm.conf2 = function() {
        vm.time();
        vm.col.rdt = vm.rdt;
        vm.col.sto = vm.ston;
        vm.col.don = vm.don;
	if(vm.sern.length == vm.sqty) {
		for(var j=0; j < vm.sern.length;j++) {
		vm.col.ser = vm.sern[j].ser;
		$http.post("/iot/serNo/",angular.copy(vm.col))
		.then(function() {
			vm.log ="ok";
		}, function() {
			alert("Error!");
		});
		}
		for(var l=0; l <vm.item.length;l++){
			if(vm.item[l].sto == vm.ston){
			vm.item[l].sta = false;
			}
		}
	}
	else {
		alert("Incorrect quantity");
	}	
	vm.getser();
	vm.clear();
    }

//	TO CLEAR THE FROM IN MODAL
    vm.clear = function() {
	vm.sern = [];
	vm.mes = [];
    }

/*------------------------------RANGE INPUT----------------------------------*/

    vm.calc = function (string1,string2) {
	string1 = string1.toUpperCase();
	vm.alpha = string1.match(/[a-z]+/ig);
	vm.snum1 = string1.match(/\d+/);
	vm.snum2 = string2.match(/\d+/);
        vm.num1 = parseInt(vm.snum1);
	vm.num2 = parseInt(vm.snum2);
	vm.zer = ("00000" + vm.num1).slice(-5);
	vm.mes = [];
	vm.ran = vm.num2 - vm.num1 + 1;
	if(vm.ran < 0 || vm.alpha == null || vm.snum1 == null || vm.snum2 == null) {
		alert("Invalid Serial NO")
	}
	else {
		for(var i=0; i < vm.ran;i++) {
		vm.pas = vm.alpha + vm.zer.toString();
		vm.zer = parseInt(vm.zer) + 1;
		vm.zer = ("00000"+vm.zer).slice(-5);
		vm.mes.push({'ser':vm.pas});
		}
	}
	vm.tes = vm.mes[4].ser;

    }
  
    vm.col2 = {};

    vm.cong = function() {
	vm.time();
	vm.col2.rdt = vm.rdt;
        vm.col2.sto = vm.ston;
	vm.col2.don = vm.don;
	if(vm.mes.length == vm.sqty) {
		for(var j=0; j < vm.mes.length;j++) {
			vm.pos(vm.mes[j].ser);
		}
		for(var l=0; l <vm.item.length;l++){
			if(vm.item[l].sto == vm.ston){
			vm.item[l].sta = false;
			}
		}	
	}
	else {
		alert("Incorrect quantity");
	}
		vm.sta = '';
		vm.las = '';
		vm.getser();
		vm.clear();
    }

    vm.pos = function(sert) {
	vm.col2.ser2 = sert;
	$http.post("/iot/range/",angular.copy(vm.col2))
	.then(function(){
		vm.log = "ok";
	}, function() {
		alert("ERROR!");
	});
    }
   
    vm.conf = function() {
	$http.get("/iot/con/"+vm.dno)
	.then(function(resp) {
                vm.show = resp.data;
		vm.log = "get strg";
        });
    }
    vm.conf();

    vm.showser = {};

    vm.getser = function() {
	$http.get("/iot/conscd/"+vm.ston)
	.then(function(resp) {
                vm.showser = resp.data;
		
        });
    }
    vm.getser();

  }
})();
