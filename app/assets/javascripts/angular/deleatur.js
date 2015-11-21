(function() {
  window.deleatur = window.angular.module('deleatur', [
    'ngTable', 'ui.utils.masks', 'ngMask', 'idf.br-filters', 'ng-rails-csrf',
    'localytics.directives', 'deleatur.filters', 'ui.sortable', 'summernote'
  ])
  .config( ['$provide', function ($provide) {
    $provide.decorator('$browser', ['$delegate', function ($delegate) {
      $delegate.onUrlChange = function() {};
      $delegate.url = function() { return '' };
      return $delegate;
    }]);
  }])
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
    };
  })

  .directive('loadingContainer', function () {
    return {
      restrict: 'A',
      scope: false,
      link: function(scope, element, attrs) {
        var loadingLayer = window.angular.element('<div class="loading"></div>');
        element.append(loadingLayer);
        element.addClass('loading-container');
        scope.$watch(attrs.loadingContainer, function(value) {
          loadingLayer.toggleClass('ng-hide', !value);
        });
      }
    };
  })

  .directive('iCheck', ['$timeout', function($timeout) {
    return {
      restrict: 'A',
      require: 'ngModel',
      link: function($scope, element, $attrs, ngModel) {
        return $timeout(function() {
          var value;
          value = $attrs['value'];

          $scope.$watch($attrs['ngModel'], function(newValue){
            $(element).iCheck('update');
          })

          return $(element).iCheck({
            checkboxClass: 'icheckbox_square-green',
            radioClass: 'iradio_square-green'

          }).on('ifChanged', function(event) {
            if ($(element).attr('type') === 'checkbox' && $attrs['ngModel']) {
              $scope.$apply(function() {
                return ngModel.$setViewValue(event.target.checked);
              });
            }
            if ($(element).attr('type') === 'radio' && $attrs['ngModel']) {
              return $scope.$apply(function() {
                return ngModel.$setViewValue(value);
              });
            }
          });
        });
      }
    };
  }])

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
}]);
})();
