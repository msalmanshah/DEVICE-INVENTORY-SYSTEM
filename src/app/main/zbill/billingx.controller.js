(function() {
  'use strict';

  angular
    .module('k7')
    .controller('BillingxController', BillingxController);

  /** @ngInject */
  function BillingxController($state, $http, $stateParams, $timeout, $log){
    var vm = this;

    vm.dbg = false;

    vm.pdr = $stateParams.pdr;

    vm.form = {}; 

    vm.getimg = false;
    vm.getmsg = false;
    vm.getpdr = false;

    $http.get("/api/billingshow/"+vm.pdr)
    .then(function(resp){
      vm.dta = resp.data;
      vm.form.pdr = vm.dta[0].pdr;
      vm.form.msg = vm.dta[0].msgt;
      if(vm.dta[0].pdrno != null)
        vm.getpdr = true;
      if(vm.dta[0].msgt != null)
        vm.getmsg = true;
      if(vm.dta[0].msgi != null)
        vm.getimg = true;
    }); 

    vm.vpm = {}; 

    if(vm.getmsg == false){
      $log.log("I am fetching previous message info...");
      $http.get("/api/getPmsg/"+vm.pdr)
      .then(function(resp){
        vm.gmsgt = resp.data;
        vm.vpm.pdr = vm.pdr;
        vm.vpm.msg = vm.gmsgt[0].msgtext;
        $log.log("(vm.vpm.msg) ->" + vm.vpm.msg);
      }); 
    }   

    vm.vpi = {}; 

    if(vm.getimg == false){
      $log.log("I am fetching previous image info...");
      $http.get("/api/getPimg/"+vm.pdr)
      .then(function(resp){
        vm.gmsgi = resp.data;
        vm.vpi.pdr = vm.pdr;
        vm.vpi.img = vm.gmsgi[0].msgimg;
        $log.log("(vm.vpi.img) ->" + vm.vpi.img);
      }); 
    }   

   /* BUTTON CODES */

   /* --------- BILLING MESSAGE --------- */
 
   vm.sub = function(){
     if(vm.getpdr){
       $http.post("/api/mvmsg", vm.form)
       .then(function(){
         alert("Update Message Successful");
       }, function(resp){
         alert("Error! " + resp.statusText);
       });
     } else {
       $http.post("/api/inmsg", vm.form)
       .then(function(){
         alert("Insert Message Successful");
       }, function(resp){
         alert("Error! " + resp.statusText);
       });
     }
   }

   vm.usePmsg = function(){
     if(vm.getpdr){
       $http.post("/api/mvmsg", vm.vpm)
       .then(function(){
         alert("Update Message Successful");
       }, function(resp){
         alert("Error! " + resp.statusText);
       });
     } else {
       $http.post("/api/inmsg", vm.vpm)
       .then(function(){
         alert("Insert Message Successful");
       }, function(resp){
         alert("Error! " + resp.statusText);
       });
     }
   }

   /* --------- BILLING IMAGE --------- */

   vm.onLoad = function(){
     $log.log('this is handler for file reader onload event!');
   }

   vm.file = [];

   vm.uimg = {};

   vm.addimg = function(){
     vm.uimg.img = vm.file.base64;
     vm.uimg.pdr = vm.pdr;

     if(vm.uimg.img == null){
       alert("No image selected");
     }
     else {
       if(vm.getpdr){
         $http.post("/api/upimg", vm.uimg)
         .then(function(){
           alert("Update Successful");
           $state.reload();
         }, function(resp){
           alert("Error! " + resp.statusText);
         });
       }
       else{
         $http.post("/api/inimgnm", vm.uimg)
         .then(function(){
           alert("Insert Successful");
         }, function(resp){
           alert("Error! " + resp.statusText);
         });
       }
     }
   }

   vm.usePimg = function(){
     if(vm.vpi.img != null){
       if(vm.getpdr){
         $http.post("/api/upimg", vm.vpi)
           .then(function(){
             alert("Update Successful");
           }, function(resp){
             alert("Error! " + resp.statusText);
           });
       }
       else{
         $http.post("/api/inimgnm", vm.vpi)
         .then(function(){
           alert("Insert Successful");
         }, function(resp){
           alert("Error! " + resp.statusText);
         });
       }
     }
     else{
       alert("No previous message found!");
     }
   }
  }
})();
