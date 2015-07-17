//= require angular/custom-filters
//= require angular/deleatur

$(document).on('page:change', function(){
  if (!angular.element('body').scope())
    angular.bootstrap(document.body, ['deleatur']);
});