(function() {
	'use strict';

	angular
		.module('k7')
    .controller('RegoController', RegoController);

  function RegoController() {
    var vm = this;

    vm.wtf = "WTF-is-it-really";

    return vm;

  }


})();



