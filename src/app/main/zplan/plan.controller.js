(function(){
  'use strict';

  angular
    .module('k7')
    .controller('PlanController', PlanController)


  /** @ngInject */
  function PlanController($http, $state) {
    var vm = this;

    vm.dbg = false;

    vm.clicksub = function(tid) {
      vm.selectedtid = tid;
      vm.log = tid;
      $state.go('plan.tid.x',{tid: tid});
    }

    vm.look4 = function(crit){
      vm.log = "";
      var c = crit;

      if (c == ""){
        c = "all";
      }

      vm.info = "Searching...";
      vm.srcst = "Searching...";

      $http.get("/api/plan/4/"+c)
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
