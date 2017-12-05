(function() {
  'use strict';

  angular
    .module('k7')
    .run(runBlock);

  /** @ngInject */
  function runBlock($log) {

    $log.debug('runBlock end');
  }

})();
