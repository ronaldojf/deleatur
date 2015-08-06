//= require angular/custom-filters
//= require angular/deleatur
//= require angular/controllers/BaseController

$(document).on('page:change', function(){
  if (!$('body').scope()) {
    window.angular.bootstrap(document.body, ['deleatur']);
  }
});