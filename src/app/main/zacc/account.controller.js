(function(){
  'use strict';

  angular
    .module('k7')
    .controller('AccountController', AccountController)
    .service('AccService', AccService);

  function AccService(){
    var details = [
      
    ];

    return{
      det:function(){
        return details;
      },
      addDet:function(snum, refr, amount){
        details.push({
          sn:snum, ref:refr, amt:amount
        });
      },
      resetDet:function(){
        return details = [];
      }
    }
  }

  /** @ngInject */
  function AccountController(AccService, $http, $log){
    var vm = this;

    vm.dbg = false;
    vm.csvst = false;
    vm.sst = "Upload CSV";
    
    vm.currdate = new Date();

    $http.get("/api/testacc")
    .then(function(resp){
      vm.sno = resp.data;
    });

    vm.getdr = function(dsr){
      $http.get("/api/report/"+dsr)
      .then(function(resp){
        $log.log(resp.data);
      }, function(){
        $log.log("Error");
      });
    }

    vm.getDetails = function() {
      return AccService.det();
    };

    vm.addDetails = function(){
      if(vm.form2.sno != null && vm.form2.amt != null){
        AccService.addDet(vm.form2.sno.sno, vm.form2.ref, vm.form2.amt);
        $log.log("details: " + vm.getDetails());
      }
      else{
        alert("add details error");
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

    vm.chks = false;

    vm.j = {};

    vm.save = function(){
      vm.list = vm.getDetails();
      vm.j.form1 = vm.form1;
      $log.log(vm.form1);
      vm.j.form2 = vm.list;
   
      $http.post("/api/upadoc", vm.j)
      .then(function(response){
        alert("Success " + response.data);
      }, function(response){
        alert("Error " + response.statusText);
      });
    }

    vm.getdata = function(){
      vm.info = "";
      
      $http.get("/api/acc/REC")
      .then(function(resp){
        vm.dta = resp.data;
      },
      function(){
        $log.log("No records found..");
      });
    }

    vm.tgl = function(){
      if(vm.csvst){
        vm.csvst = false;
        vm.sst = "Upload CSV";
      } else {
        vm.csvst = true;
        vm.sst = "Hide CSV Uploader";
      }
    }

    vm.csv = {
      content: null,
      header: true,
      headerVisible: true,
      separator: ',',
      separatorVisible: false,
      result: null,
      encoding: 'ISO-8859-1',
      encodingVisible: false,
      accept: ".csv"
    }

    vm.upcsv = function(csvd){
      for(var i=0; i<csvd.length; i++){
        AccService.addDet(csvd[i].sno, csvd[i].ref, csvd[i].amt);
        $log.log("Array " + i + "SN: " + csvd[i].sno + " REF: " + csvd[i].ref + " AMT: " + csvd[i].amt);
      }
      vm.csv.result = null;
    }

    vm.getdata();
  }
})();
