(function() {
  'use strict';

  angular
    .module('k7')
    .controller('LedgerController', LedgerController)
    ;

  /** @ngInject */
  function LedgerController($http,$stateParams) {

    var vm = this;

    vm.dbg = false;
    vm.sno = $stateParams.sn
    vm.abc = 'abc'
    //vm.dta =[{"ac":"A103","sn":"0101111187","si":"502151123456894","st":1,"nm":"PAUL CITIZEN","ad":null}];

    vm.chg = function(){
      $http.get("/api/"+vm.form.sel+"/"+vm.sno)
      .then(function(response){
        vm.dta = response.data;
      });
    }

    $http.get("/api/ldgrcv/"+vm.sno)
    .then(function(response) {
      vm.dta = response.data;
    });

    //vm.info = vm.dta;  
  }
})();
