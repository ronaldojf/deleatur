deleatur
  .controller('AdministratorsController', ['$scope', '$http', 'ngTableParams', function($scope, $http, ngTableParams) {
    $scope.filters = {};
    $scope.tableParams = new ngTableParams({
      page: 1,
      count: 25,
      sorting: {name: 'asc'},
      filter: $scope.filters,
    }, {
      total: 0,
      getData: function($defer, params) {
        window.params = params;
        var request = params.url();
        request['format'] = 'json';

        $http.get(Routes.administrators_path(request))
          .success(function success(data) {
            $scope.total = data.total;
            params.total(data.total);
            $defer.resolve(data.result);
          });
      }
    });

    $scope.select = function(event, administrator) {
      event.preventDefault();
      if ($scope.administrator === administrator) {
        $scope.administrator = null;
      } else {
        $scope.administrator = administrator;
      }
    }
  }]);
