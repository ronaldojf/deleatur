$(document).on('page:change', function() {
  window.app = new window.App();

  $('form.protected *, .protected form *').on('change', function() {
    window.app.markDirty();
  });

  $("a[href^='/'], a[href^='/'] *").on('click', function(e) {
    if (window._isDirty) {
      var target = $(e.target);

      if (target.is('a')) {
        window.hrefDirty = target.attr('href');
      } else {
        window.hrefDirty = target.parents("a[href^='/']:first").attr('href');
      }
    }
  });

  $("div.form form").on("submit", function() {
    window.app.clearDirty();
  });

  $.rails.allowAction = function(link) {
    if (!link.attr('data-confirm')) {
      return true;
    }
    $.rails.showConfirmDialog(link);
    return false;
  };

  $.rails.confirmed = function(link) {
    if (link.attr('data-method')) {
      link.removeAttr('data-confirm');
      link.trigger('click.rails');
    } else {
      window.Turbolinks.visit(link.attr('href'));
    }
  };

  $.rails.showConfirmDialog = function(link) {
    var message = link.attr('data-confirm');
    window.swal({
      title: window.I18n.t('js.messages.titles.sure'),
      text: message,
      type: 'warning',
      showCancelButton: true,
      customClass: 'data-confirm-swal'
    });

    $('.data-confirm-swal .confirm, .data-confirm-swal .cancel').off('click');
    $('.data-confirm-swal .confirm').on('click', function() { $.rails.confirmed(link); });
    $('.data-confirm-swal .cancel').on('click', function() { $('.data-confirm-swal .confirm').off('click'); });
  };
});

$(document).on('page:before-change', function(e) {
  if (window._isDirty && window.hrefDirty) {
    e.preventDefault();
    window.swal({
      title: window.I18n.t('js.messages.titles.sure'),
      text: window.I18n.t('js.forms.unsaved.quit'),
      type: 'warning',
      showCancelButton: true,
      customClass: ''
    }, function(confirmed) {
      if (confirmed) {
        var path = window.hrefDirty;
        window.app.clearDirty();
        window.Turbolinks.visit(path);
      }
    });
  }
});