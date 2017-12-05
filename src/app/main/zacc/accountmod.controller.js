(function(){
  'use strict';

  angular
    .module('k7')
    .controller('AccountmodController', AccountmodController)
    .service('AccService', AccService);

  function AccService(){
    var details = [ 
    
    ];  

    return{
      det:function(){
        return details;
      },  
      addDet:function(snum, refr, amount, rdate, dref, ddate, dmod, nrr){
        details.push({
          sn:snum, ref:refr, amt:amount, recDt:rdate, docRf:dref, docDt:ddate, docMd:dmod, narr:nrr
        });
      },  
      resetDet:function(){
        return details = []; 
      }   
    }   
  }

  function AccountmodController(PassData, AccService){
    var vm = this;

    vm.getDetails = function() {
      return AccService.det();
    };  

    vm.getins = PassData.getmsg();

    vm.newval = {};

    vm.newval.recDt = vm.getins.recDt;
    vm.newval.docRf = vm.getins.docRf;
    vm.newval.docDt = vm.getins.docDt;
    vm.newval.docMd = vm.getins.docMd;
    vm.newval.narr = vm.getins.narr;

    vm.addDetails = function(){
      alert(vm.getins);
      if(vm.form2.sno != null && vm.form2.amt != null && vm.newval.recDt != null){
        AccService.addDet(vm.form2.sno, vm.form2.ref, vm.form2.amt, vm.newval.recDt, vm.newval.docRf, vm.newval.docDt, vm.newval.docMd, vm.newval.narr);
      }
      else{
        alert("fail to add details");
      }
    };  
  
    vm.resetD = function(){
      AccService.resetDet();
    }   
 
    vm.resetF = function(){
      vm.form2.sno = ''; 
      vm.form2.ref = ''; 
      vm.form2.amt = ''; 
    } 
  }
})();
