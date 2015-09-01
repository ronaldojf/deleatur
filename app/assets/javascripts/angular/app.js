//= require angular/custom-filters
//= require angular/deleatur
//= require angular/controllers/NgTableController

$(document).on('page:change', function(){
  if (!$('body').scope()) {
    window.angular.bootstrap(document.body, ['deleatur']);
  }
});