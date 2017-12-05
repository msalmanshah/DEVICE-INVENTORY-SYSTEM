(function(){
  'use strict';

  angular
    .module('k7')
    .controller('BillingController', BillingController)
    .filter('StatP', StatP)


  function StatP() {
    return function(sta) {
           if (sta == 0) { return "OPEN"  }
      else if (sta == 1) { return "GENERATED" }
      else if (sta > 2) { return "CLOSED" }
      else              { return "NULL" }
    }
  }

  /** @ngInject */
  function BillingController($http, $state) {

    var vm = this;

    vm.dbg = false;

    vm.clicksub = function(pdr) {
      vm.selectedpdr = pdr;
      vm.log = pdr;
      $state.go('bill.pdr.x',{pdr: pdr});
    }

    vm.look4 = function(crit){
      vm.log = "";
      var c = crit;

      if (c == "") {
        c = "all";
      }

      vm.info = "Searching....";
      vm.srcst = "Searching...";

      $http.get("/api/billing/4/"+c)
      .then(function(resp){
        vm.len = resp.data.sz;
        vm.log += "[look4()] ["+c+"] got http.get results on, ";

        vm.dta = resp.data;
        vm.srcst = vm.len + "Record(s)";
        vm.log += "[look4()] ["+c+"] got "+vm.srcst;
      },
      function () {
        vm.log += "[look4()] ["+c+"] got Error searching Postpaid";
        vm.srcst = "Not found ... ";
      })
      .then(function(){
        vm.info = "";
      });
    }
    
    vm.look4("");
  }
})();
