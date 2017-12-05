(function() {
  'use strict';

  angular
    .module('k7')
    .controller('PstController', PstController)
    ;

  /** @ngInject */
  function PstController($http,$stateParams,$log,$state,$timeout) {

    var vm = this;
    
    vm.dbg = false;

    vm.hello = "HELLO!";
   
    vm.sn = $stateParams.sn;
    //vm.sn = "1234567"
    vm.abc = 'abc'
    vm.dta =[{"ac":"A103","sn":"0101111187","si":"502151123456894","st":1,"nm":"PAUL CITIZEN","ad":null}];
    vm.stk = [{"nme":"ABU BIN AHMAD","typ":"SPONSOR","sno":"0198887777","alm":"A,S","sta":1},{"nme":"ALI BIN AHMAD","typ":"FAMILY","sno":"0198886655","alm":"S","sta":1},{"nme":"DR JOHN DOE","typ":"PHYSICIAN","sno":"0123218765","alm":"S","sta":1},{"nme":"SITI BINTI ABU","typ":"FAMILY","sno":"0198887979","alm":"A,S","sta":1}]
  
    vm.getfta = function() {
        $http.get("/getfta")
        .then(function(resp) {
            vm.fta = resp.data;
        });
    }
    vm.getfta();
   
    vm.shown = false;
    vm.sta = false;
    vm.expand = function(sta,ser,typ,index) {
       if(sta == 0)
           vm.sta = true;
       else 
           vm.sta = false;
       vm.shown = true;
       vm.show1 = false;
       vm.show2 = false;
       vm.ser = ser;
       vm.typ = typ;
       vm.index = index;
    }

    vm.activate = function(ser) {
       $http.post("/iot/act/"+ser)
       .then(function() { } );
       vm.sta = true;
    }
 
    vm.deactivate = function(ser) {
       $http.post("/iot/deact/"+ser)
       .then(function() { } );
       vm.sta = false;
    }

    vm.refresh = function() {
       $state.reload();
    }     

    vm.gsub = function(){
      $http.get("/api/nshowsub/"+vm.sn)
      .then(function(response) {
        vm.dta = response.data;
        vm.zacc = vm.dta[0].acc;
        vm.form.acc = vm.dta[0].acc;
      });
    }

    vm.info = vm.dta;  

    vm.form = {};
      vm.form.email = vm.form.email;
      vm.form.acc = vm.form.acc;
    $log.log(vm.form.acc);

    vm.save = function(){
      $http.post("/api/ecacc/", vm.form)
      .then(function(){
        $log.log("email: " + vm.form.email + "acc: " + vm.form.acc);
        alert("Email Updated");
      }, function(resp){
        alert("Error! " + resp.statusText);
      });
    }

    vm.gsub();

    vm.getih = function() {
      // $http.get("/api/ihis/"+vm.sn)
      $http.get("/api/ihis/"+vm.zacc)
      .then(function(resp){
        vm.ihd = resp.data;
        $log.log(vm.ihd);
      });
    }

    vm.getih();

    vm.chose = function() {
	$http.get("/iot/choose")
	.then(function(resp) {
		vm.loca = resp.data;
        });
    }
    vm.chose();

    vm.show = function(loct) {
	$http.get("/iot/stock/"+loct)
	.then(function(resp) {
		vm.stoc = resp.data;
        });
    }

    vm.show1 = false;
    vm.show2 = false;
  
    vm.adDev = function(scd,sno) {
	$http.post("/iot/adDev/"+scd+"/"+sno)
	.then(function() {
		vm.log = "OK";
	});
    }

    vm.upClic = function() {
	$timeout(function() {vm.show1 = true;}, 3000)
    }

    vm.doClic = function() {
	$timeout(function() {vm.show2 = true;},3000);
    }
  
    vm.close = function() {
	vm.show1 = false;
	vm.show2 = false;
    }

  }
})();
