//= require angular/custom-filters
//= require angular/deleatur
//= require angular/controllers/NgTableController
//= require_tree ./controllers

$(document).on('page:change', function(){
  if (!$('body').scope()) {
    window.angular.bootstrap(document.body, ['deleatur']);
  }
});