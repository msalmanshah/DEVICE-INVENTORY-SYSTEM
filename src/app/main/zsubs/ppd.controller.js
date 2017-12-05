(function() {
  'use strict';

  angular
    .module('k7')
    .controller('PpdController', PpdController)
    ;

  /** @ngInject */
  function PpdController($rootScope,$http,$stateParams,PassData) {

    var vm = this;

    vm.sn = $stateParams.sn;
    vm.abc = 'abc'

    vm.dta =[{"ac":"A103","sn":"0101111187","si":"502151123456894","st":1,"nm":"PAUL CITIZEN","ad":null}];
    vm.dta = PassData.getmsg();
    vm.log += "In PpdController:"+vm.dta
/*
    $http.get("/api/nshowsub/"+vm.sn)
      .then(function(response) {
        vm.sndata = response.data;
      });
*/
  }
})();

