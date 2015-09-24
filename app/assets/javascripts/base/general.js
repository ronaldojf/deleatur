$(document).on('page:change', function() {

  window.localizedPath = function() {
    var pathPrefix = [].shift.apply(arguments);
    return window.Routes[pathPrefix + window.I18n.pathLocale].apply(this, arguments);
  };

  $('.show-action-label').append('<div class="clearfix"></div>');

  if ($('html.no-touch').length > 0) {
    setTimeout(function() {
      $('[responsive-focus]:first').focus();
    }, 500);
  }

  if ($('[fake-password]').length > 0 && !$($('[fake-password]').parent()).hasClass('has-error')) {
    window.fakePassword = Math.random().toString(36).substring(8);
    $('[fake-password]').val(window.fakePassword);

    $('[fake-password]').on('focus', function() {
      if ($(this).val() === window.fakePassword) {
        $(this).val('');
      }
    });

    $('[fake-password]').on('blur', function() {
      if ($(this).val().length <= 0) {
        $(this).val(window.fakePassword);
      }
    });

    $('form').on('submit', function() {
      $('[fake-password]').each(function() {
        if ($(this).val() === window.fakePassword) {
          $(this).val('');
        }
      });
    });
  }

  $('.datepicker').each(function() {
    var target = $(this);

    target.wrap('<div class="input-group date"></div>');
    $(target.parent()).append(
      '<label for="' + target.attr('id') + '" class="input-group-addon">' +
        '<i class="fa fa-calendar"></i>' +
      '</label>');

    target.datepicker({
      startView: parseInt(target.attr('data-start-view') || 0),
      forceParse: true,
      keyboardNavigation: false,
      autoclose: true,
      orientation: 'right',
      language: window.I18n.locale,
      format: target.attr('data-format') || window.I18n.t('js.date.formats.default')
    });
  });

  $('.iCheck').each(function() {
    var target = $(this);
    target.iCheck({
      checkboxClass: target.attr('data-class') ? ('icheckbox_' + target.attr('data-class')) : 'icheckbox_square-green',
      radioClass: target.attr('data-class') ? ('iradio_' + target.attr('data-class')) : 'iradio_square-green'
    });
  });

  setTimeout(function() {
    if ($('[chosen]').length > 0) {
      $('[chosen]').data('chosen').results_none_found = window.I18n.t('js.chosen.results_none_found');
    }
  });
});