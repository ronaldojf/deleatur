$(function() {
  Turbolinks.enableProgressBar();
});

$(document).on('page:change', function() {
  $('[data-summernote]').summernote({
    lang: 'pt-BR'
  });

  setTimeout(function() {
    $("[autofocus]:first").focus();
  }, 500);
});