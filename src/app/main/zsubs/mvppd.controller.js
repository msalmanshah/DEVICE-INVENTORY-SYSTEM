(function() {
  'use strict';

  angular
    .module('k7')
    .controller('MvppdController', MvppdController)
    ;


  function MvppdController($http,$state,$log,$timeout,PassData) {
    var vm = this;
    var ppdta = PassData.getmsg()

    vm.rqdep = 500;

    vm.cb = ppdta.currentbalance;
    $log.log(vm.cb);

    if(vm.cb > vm.rqdep){
      vm.vdp = vm.cb;
      vm.tcl = vm.cb;
      vm.dep = 0;
    }else {
      vm.vdp = vm.cb;
      vm.tcl = vm.rqdep;
      vm.dep = vm.rqdep - vm.cb;
    }

    vm.form = {};
  
          vm.form.rf1  = ppdta.accountid;
          vm.form.sub  = ppdta.firstname || ''; 
          if (ppdta.lastname) { vm.form.sub += ' ' + ppdta.lastname; }
          vm.form.acn  = vm.form.sub; 
          vm.form.adr  = ppdta.addr1; 
          vm.form.ad2  = ppdta.addr2; 
          vm.form.ad3  = ppdta.city; 
          vm.form.ads  = ppdta.statecode; 
          //if (ppdta.addr2)    { vm.form.adr += ' ' + ppdta.addr2; }
          vm.form.zip  = ppdta.postalcode || '';
          vm.form.idn  = ppdta.personalidentificationnumber || '';
          vm.form.sim  = ppdta.imsi;
          if (/^\d{7}$/.test(ppdta.msisdn)) { ppdta.msisdn = "010"+ ppdta.msisdn; }
          else                              { ppdta.msisdn = ppdta.msisdn.replace(/^6?0?(11?)/,"0$1");}
          vm.form.sno  = ppdta.msisdn;
          vm.form.dep = vm.dep;
          vm.form.pln = vm.form.pln;
          vm.form.vdp = vm.vdp;
          vm.form.tcl = vm.tcl;     

    $http.get("/api/refs/plans")
    .then( function(response) {
         vm.plnlst = response.data;
    });

    vm.mvsub = function() {
      $log.log("move sub" + vm.form.vdp);
  
      if(vm.form.pln == 'vip01'){
        vm.form.kls = "1";
      } else {
        vm.form.kls = "5";
      } 

 
      $http.post("/api/mvsub", vm.form)
        .then(
        function () {
        //function (response) {
          //vm.mvstatus = response;
          alert("Moved");
        }, function(response) {
          alert("Move Error:" + response.statusText);
        })
        
        .then (
        function() {
          $timeout(function() {
            angular.element('#btnclose').triggerHandler('click');
          });
        }
        )
        
        ;
    }
    
    vm.getppd = function() {

      var url = "/api/ttsa/a/"+vm.form.sno;

      $http.get(url)
        .then(function(response) {

          vm.form.rf1  = response.data.accountid;
          vm.form.sub  = response.data.firstname || ''; 
          if (response.data.lastname) { vm.form.sub += ' ' + response.data.lastname; }
          vm.form.adr  = response.data.addr1 || ''; 
          if (response.data.addr2)    { vm.form.adr += ' ' + response.data.addr2; }
          vm.form.zip  = response.data.postalcode || '';
          vm.form.idn  = response.data.personalidentificationnumber || '';
          vm.form.sim  = response.data.imsi;
          vm.form.acn  = vm.form.sub;

       });
    }
  }

})();
