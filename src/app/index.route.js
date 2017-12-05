(function() {
  'use strict';

  angular
    .module('k7')
    .config(routerConfig);

  /** @ngInject */
  function routerConfig($stateProvider, $urlRouterProvider) {
    var st = [];

    st.push({
      name:   'subs'
      ,url: '/subs'
      ,templateUrl: 'app/main/zsubs/subs.html'
      ,controller: 'SubsController'
      ,controllerAs: 'subs'
    });

    st.push({
      name:   'subs.pst', url: '/pst/:sn'
      ,views:  { 'tabpage@subs':  {
        //abstract: true
        templateUrl: 'app/main/zsubs/pst.html'
        ,controller: 'SubsController'
        ,controllerAs: 'subs'
      }}
      //,deepStateRedirect: true, sticky: true       
    });

    st.push({
      name:   'subs.pst.x'
      ,url: '/x'
      ,templateUrl: 'app/main/zsubs/pstsub.html'
      ,controller: 'PstController'
      ,controllerAs: 'pst'
    });

    st.push({
      name:   'subs.pst.x.bill'
      ,url: '/bill'
      ,views:  { 'subtabpage':  {
        //abstract: true
         templateUrl: 'app/main/zsubs/pstbill.html'
        ,controller: 'BillController'
        ,controllerAs: 'billc'
      }}
      //,deepStateRedirect: true, sticky: true       

    });

    st.push({
      name:   'subs.pst.x.cctl'
      ,url: '/cctl'
      ,views:  { 'subtabpage':  {
         templateUrl: 'app/main/zsubs/pstcctl.html'
        ,controller: 'CctlController'
        ,controllerAs: 'ccrc'
      }}
      //,deepStateRedirect: true, sticky: true       
    });

    st.push({
      name: 'subs.pst.x.legr'
      ,url: '/legr'
      ,views: { 'subtabpage': {
        templateUrl: 'app/main/zsubs/pstlegr.html'
        ,controller: 'LedgerController'
        ,controllerAs: 'legrc'
      }}
      //,deepStateRedirect: true, sticky: true
    });

    st.push({
      name:   'subs.pst.x.logs'
      ,url: '/logs'
      ,views:  { 'subtabpage':  {
         templateUrl: 'app/main/zsubs/pstlogs.html'
        ,controller: 'SubsController'
        ,controllerAs: 'logsc'
      }}
      //,deepStateRedirect: true, sticky: true       
    });

    st.push({
      name:   'subs.ppd', url: '/ppd/:sn'
      ,views:  { 'tabpage@subs':  {
        //abstract: true
        templateUrl: 'app/main/zsubs/ppd.html'
        ,controller: 'PpdController'
        ,controllerAs: 'ppd'
      }}
      ,deepStateRedirect: true, sticky: true       
    });

    st.push({
      name:   'subs.ppd.x'
      ,url: '/x'
      ,templateUrl: 'app/main/zsubs/ppdsub.html'
      ,controller: 'PpdController'
      ,controllerAs: 'ppd'
    });

    st.push({
      name: 'bill'
      ,url: '/bill'
      ,templateUrl: 'app/main/zbill/bill.html'
      ,controller: 'BillingController'
      ,controllerAs: 'billing'
    });

    st.push({
      name: 'bill.pdr'
      ,url: '/pdr/:pdr'
      ,views: { 'tabpage@bill': {
         templateUrl: 'app/main/zbill/billpdr.html'
         ,controller: 'BillingController'
         ,controllerAs: 'billing'
       }}
      ,deepStateRedirect: true, sticky: true
    });

    st.push({
      name: 'bill.pdr.x'
      ,url: 'x'
      ,templateUrl: 'app/main/zbill/billpdrx.html'
      ,controller: 'BillingxController'
      ,controllerAs: 'bxc'
    });

    st.push({
      name: 'plan'
      ,url: '/plan'
      ,templateUrl: 'app/main/zplan/plan.html'
      ,controller: 'PlanController'
      ,controllerAs: 'plan'
    });

    st.push({
      name:   'plan.tid'
      ,url: '/plan/:tid'
      ,views:  { 'tabpage@plan':  {
         templateUrl: 'app/main/zplan/planchg.html'
         ,controller: 'PlanController'
         ,controllerAs: 'plan'
        }}
        ,deepStateRedirect: true, sticky: true
      });

     st.push({
      name: 'plan.tid.x'
      ,url: 'x'
      ,templateUrl: 'app/main/zplan/planchgx.html'
      ,controller: 'PlanxController'
      ,controllerAs: 'planx'
    });

    st.push({
      name: 'acc'
      ,url: '/acc'
      ,templateUrl: 'app/main/zacc/acc.html'
      ,controller: 'AccountController'
      ,controllerAs: 'acc'
    });

//------------------------------GOODS RECEIVED------------------------------//

    st.push({
        name: 'deli'
        ,url: '/deli'
        ,templateUrl: 'app/main/greceived/deli.html'
        ,controller: 'DeliveryController'
        ,controllerAs: 'deli'
    });

    st.push({
        name: 'deli.exter'
        ,url: '/exter'
        ,views: { "deltab": {
                templateUrl: 'app/main/greceived/exter.html'
                ,controller: 'DeliveryController'
                ,controllerAs: 'deli'
        }}
    });

     st.push({
        name: 'deli.inter'
        ,url: '/inter'
        ,views: { 'deltab': {
                templateUrl: 'app/main/greceived/inter.html'
                ,controller: 'DeliveryController'
                ,controllerAs: 'deli'
        }}
    });

    st.push({
        name: 'deli.exter.table'
        ,url: '/table/:don'
        ,views: { 'input': {
                templateUrl: 'app/main/greceived/table.html'
                ,controller: 'ExteryController'
                ,controllerAs: 'exte'
        }}
    });

     st.push({
        name: 'deli.inter.show'
        ,url: '/show/:dno'
        ,views: { 'show': {
                templateUrl: 'app/main/greceived/confirm.html'
                ,controller: 'ExteryController'
                ,controllerAs: 'exte'
        }}
    });

    

//-------------------------------GOODS DELIVERY------------------------------//
    
    st.push({
      name: 'gdel'
      ,url: '/gdel'
      ,templateUrl: 'app/main/gdel/mdel.html'
      ,controller: 'DeliController'
      ,controllerAs: 'deli'
    });

    st.push({
	name: 'gdel.external'
	,url: '/exter'
	,views: { 'deltab@gdel' : {
		templateUrl: 'app/main/gdel/exdel.html'
		,controller: 'ExterController'
		,controllerAs: 'exte'
	}}
    });

    st.push({
	name: 'gdel.internal'
	,url: '/inter'
	,views: { 'deltab@gdel' : {
		templateUrl: 'app/main/gdel/indel.html'
		,controller: 'InterController'
		,controllerAs: 'inte'
	}}
    });

    st.push({
	name: 'gdel.external.view'
	,url: '/view/:cloc/:rloc'
	,views: { 'input' : {
		templateUrl: 'app/main/gdel/stocka.html'
		,controller: 'ExterController'
		,controllerAs: 'exte'
	}}
    });

    st.push({
	name: 'gdel.internal.view2'
	,url: '/view2/:cloc/:rloc'
	,views: { 'input' : {
		templateUrl: 'app/main/gdel/bstock.html'
		,controller: 'InterController'
		,controllerAs: 'inte'
	}}
    });

    st.push({
	name: 'temp'
	,url: '/temp'
	,templateUrl: 'app/main/gdel/exdel.html'
        ,controller: 'ExterController'
	,controllerAs: 'exte'
    });

    angular.forEach(st, function(state){ $stateProvider.state(state); });
    $urlRouterProvider.otherwise('/subs');

  }

})();
