(function() {
  'use strict';

  angular
    .module('k7')
    .controller('PlanxController', PlanxController)
    .filter('StatX', StatX)

  function StatX() {
    return function(ctp) {
           if (ctp == 1) { return "Daily"  }
      else if (ctp == 2) { return "Weekly" }
      else if (ctp == 3) { return "Fortnightly" }
      else if (ctp == 4) { return "Monthly" }
      else if (ctp == 5) { return "Annually" }
      else              { return "NULL" }
    }
  }

   /** @ngInject */
  function PlanxController($http, $stateParams) {
    var vm = this;

    vm.dbg = false;

    vm.tid = $stateParams.tid;

    vm.abc = 'abc';

    vm.form = {};

    $http.get("/api/planshow/"+vm.tid)
    .then(function(response) {
      vm.dta = response.data;
    });

    $http.get("/api/planshows/"+vm.tid)
    .then(function(response) {
      vm.data = response.data;
    });




  }
})();
