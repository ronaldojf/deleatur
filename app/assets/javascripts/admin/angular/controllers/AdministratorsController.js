deleatur
  .controller('AdministratorsController', ['$scope', '$http', 'ngTableParams', function($scope, $http, ngTableParams) {
    $scope.filters = {};
    $scope.loading = true;
    $scope.infoMessage = I18n.t('js.info.loading');

    $scope.tableParams = new ngTableParams({
      page: 1,
      count: 25,
      sorting: {name: 'asc'},
      filter: $scope.filters,
    }, {
      total: 0,
      getData: function($defer, params) {
        var request = params.url();
        request['format'] = 'json';
        request['clear'] = $scope.filters['clear'];
        $scope.loading = true;

        $http.get(Routes['admin_administrators_' + I18n.pathLocale](request))
          .success(function (data) {
            params.total(data.total);
            $defer.resolve(data.result);
          })
          .finally(function(data) {
            delete $scope.filters['clear'];
            $scope.infoMessage = I18n.t('js.info.records_found_html', {count: data.total});
            $scope.loading = false;
          });
      }
    });

    $scope.clearFilters = function() {
      $scope.filters = {clear: true};
      angular.element("#filter").focus();
    };
  }]);
