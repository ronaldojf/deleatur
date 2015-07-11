(function() {
  window.deleatur = angular.module('deleatur', ['ngTable', 'ui.utils.masks'])

  .directive('ngEnter', function() {
    return function(scope, element, attrs) {
      element.bind('keydown keypress', function(event) {
        if(event.which === 13) {
          scope.$apply(function(){
            scope.$eval(attrs.ngEnter, {'event': event});
          });

          event.preventDefault();
        }
      });
    }
  })

  .directive('loadingContainer', function () {
    return {
      restrict: 'A',
      scope: false,
      link: function(scope, element, attrs) {
        var loadingLayer = angular.element('<div class="loading"></div>');
        element.append(loadingLayer);
        element.addClass('loading-container');
        scope.$watch(attrs.loadingContainer, function(value) {
          loadingLayer.toggleClass('ng-hide', !value);
        });
      }
    };
  })

  .directive('ngFocus', ['$timeout', function($timeout) {
    return {
      link: function(scope, element, attrs) {
        scope.$watch(attrs.ngFocus, function(value) {
          if((Array.isArray(value) && value[0] === true) || (value === true)) {
            $timeout(function() {
              element[0].focus();
              scope[attrs.ngFocus] = false;
            }, Array.isArray(value) ? value[1] : 0);
          }
        });
      }
    };
  }])
})();

$(document).on('page:change', function(){
  angular.bootstrap(document.body, ['deleatur']);
});
