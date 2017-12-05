(function(){
  'use strict';

  angular
    .module('k7')
    .controller('CctlController', CctlController);

  function CctlController($log, $http, $stateParams){

    var vm = this;

    vm.sno = $stateParams.sn

    vm.cctl = function(){
      $http.get("/api/cctl/"+vm.sno)
       .then( function(response) {
            vm.dta = response.data;
            vm.form.ocrl = vm.dta[0].tcl;
            vm.form2.acc = vm.dta[0].acc;
            vm.getst = vm.dta[0].st;

            if(vm.getst == 1){
              vm.btst = true;
              vm.ubtst = false;
              $log.log(vm.btst + ".." + vm.ubtst);
            }
            else if(vm.getst > 1 && vm.getst < 8){ 
              vm.btst = false;
              vm.ubtst = true;
              $log.log(vm.btst + ".." + vm.ubtst);
            }
            else{
              $log.log(vm.getst);
            }
       });
    }

    vm.reset = function(){
      vm.cctl();
    }

    vm.form = {};
    
      vm.form.sno = vm.sno;
      vm.form.crl = vm.form.crl;

    vm.form2 = {};

      vm.form2.sno = vm.sno;
      vm.form2.res = vm.form2.res;
      vm.form2.acc = vm.form2.acc;
      vm.form2.cmt = vm.form2.cmt;

    vm.form3 = {};

      vm.form3.sno = vm.sno;
      vm.form3.cmt = vm.form3.cmt;

    vm.b1 = function(){
      $http.post("/api/ttsa/prov/barr/"+vm.sno, vm.form2)
      .then(function(){
        alert("Successful");
      }, function(resp){
        alert("Error! " + resp.statusText);
      });
    }

    vm.ub1 = function(){
      $http.post("/api/ttsa/prov/unbarr/"+vm.sno, vm.form3)
      .then(function(){
        alert("Unbarr successful");
      }, function(resp){
        alert("Error! " + resp.statusText);
      });
    }


    vm.b2 = function(){
      $http.post("/api/ccrlc", vm.form)
      .then(function(){
        alert("Successful");
      }, function(resp){
        alert("Error! " + resp.statusText);
      });
    }

    vm.cctl();

  }
})();
