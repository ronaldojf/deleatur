deleatur
  .controller('BaseController', ['$scope', '$http', '$sce', 'ngTableParams', function($scope, $http, $sce, ngTableParams) {

    $scope.initTable = function(config, pathPrefix) {
      $scope.config = config;

      $scope.tableParams = new ngTableParams({
        page: $scope.config.page,
        count: 25,
        sorting: $scope.config.sorting,
        filter: $scope.config.filter,
      }, {
        total: 0,
        getData: function($defer, params) {
          var request = params.url();
          request.format = 'json';

          $scope.loading = true;
          $scope.infoMessage = $sce.trustAsHtml(window.I18n.t('js.info.loading'));

          $http.get(Routes[pathPrefix + window.I18n.pathLocale](request))
            .success(function(data) {
              $scope.loading = false;
              $scope.infoMessage = $sce.trustAsHtml(window.I18n.t('js.info.records_found_html', {count: data.total}));
              params.total(data.total);
              $defer.resolve(data.result);
            })
            .error(function() {
              $scope.loading = false;
              $scope.infoMessage = $sce.trustAsHtml(window.I18n.t('js.errors.searching_records'));
          });
        }
      });
    };

    $scope.clearFilters = function() {
      $scope.config.filter.general = '';
      $('#filter').focus();
    };
  }]);