(function() {
  'use strict';

  angular
    .module('k7')
    .controller('BillController', BillController)
    .service('PassBill', PassBill);

  function PassBill(){
    var edt = [

    ];

    return{
      edet: function(){
        return edt;
      },
      addEdt: function(anum, prf){
        edt.push({
          acno: anum, pdrn: prf
        });
      },
      rEdt: function(){
        return edt = [];
      }
    }
  }

  /** @ngInject */
  function BillController(PassBill,$log,$location,$http,$stateParams) {

    var vm = this;
    
    // to pass to the pdf maker program
    vm.port= $location.port();
    vm.dbg = false;
    vm.sno = $stateParams.sn
    vm.abc = 'abc'
    vm.dta =[{"ac":"A103","sn":"0101111187","si":"502151123456894","st":1,"nm":"PAUL CITIZEN","ad":null}];

    vm.cstb = true;
    vm.cstu = false;

    $log.log("vm.cstb: " + vm.cstb + "vm.cstu: " + vm.cstu);
 
    vm.chg = function(){
      $log.log("vm.cstb: " + vm.cstb + "vm.cstu: " + vm.cstu);
      if(vm.sel == "bill"){
        vm.cstb = true;
        vm.cstu = false;
        $http.get("/api/bills/"+vm.sno)
        .then(function(response) { 
          vm.dta = response.data;
        });
      } else{
        vm.cstb = false;
        vm.cstu = true;
        $http.get("/api/ubills/"+vm.sno)
        .then(function(resp){
          vm.bdta = resp.data
        });
      }
    }

    $http.get("/api/bills/"+vm.sno)
    .then(function(response) {
      vm.dta = response.data;
      vm.form.edml = vm.dta.eml;
    });

    $http.get("/api/ubills/"+vm.sno)
    .then(function(resp){
      vm.bdta = resp.data
    });

    vm.getD = function(){
      return PassBill.edet();
    }

    vm.edta = function(acno, pdrno) {
      PassBill.addEdt(acno, pdrno);
    }

    vm.form = {};

      vm.form.edeml = vm.form.edeml;

    vm.seml = function() {
      $log.log(vm.getD()[0].acno + " <- acno | pdrn -> " + vm.getD()[0].pdrn);
      $http.post("/api/sendbillz/"+vm.getD()[0].acno+"/"+vm.getD()[0].pdrn, vm.form)
      .then(function(){
        alert("Email sent to " + vm.form.edeml);
      }, function(resp){
        alert("Error!" + resp.statusText);
      });

    }

    //vm.info = vm.dta;  
  }
})();
