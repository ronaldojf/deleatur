//= require angular/custom-filters
//= require angular/deleatur

$(document).on('page:change', function(){
  if (!$('body').scope()) {
    window.angular.bootstrap(document.body, ['deleatur']);
  }
});