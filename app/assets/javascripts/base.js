$(function() {
  window.Turbolinks.enableProgressBar();

  window.localizedPath = function(args) {
    var pathPrefix = [].shift.apply(arguments);
    return window.Routes[pathPrefix + window.I18n.pathLocale].apply(this, arguments);
  };

  window.App = function() {
    this.binds();
  };

  App.prototype.markDirty = function() {
    if (!window._isDirty) {
      $(window).bind("beforeunload", function(e){
        var message = window.I18n.t('js.forms.unsaved.default');

        e = e || window.event;
        e.returnValue = message;
      });
    }
    window._isDirty = true;
  };

  App.prototype.clearDirty = function() {
    window._isDirty = false;
    window.hrefDirty = undefined;
    $(window).unbind("beforeunload");
  };

  App.prototype.binds = function() {
    $('[data-toggle=tooltip]').on('click', function(e) { e.preventDefault(); }).tooltip();

    $('[data-form-submit]').on('click', function(e) {
      var form = $("[action='" + $(this).data('form-submit') + "']");

      if (form.find("input[type='submit']").length > 0) {
        form.find("input[type='submit']").click();
      } else {
        form.submit();
      }

      e.preventDefault();
    });

    $('body').on('click', 'tr[data-href] td:not([data-no-href])', function() {
      window.Turbolinks.visit($(this).parents('tr:first').data('href'));
    });

    if ($('html.no-touch').length > 0) {
      setTimeout(function() {
        $('[responsive-focus]:first').focus();
      }, 500);
    }

    if ($('[fake-password]').length > 0) {
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
  };

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
        confirmButtonColor: '#1ab394',
        cancelButtonColor: '#f3f3f4',
        confirmButtonText: window.I18n.t('js.buttons.ok'),
        cancelButtonText: window.I18n.t('js.buttons.cancel')
      });
      $('.sweet-alert .confirm').on('click', function() { $.rails.confirmed(link); });
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
        confirmButtonColor: '#1ab394',
        cancelButtonColor: '#f3f3f4',
        confirmButtonText: window.I18n.t('js.buttons.ok'),
        cancelButtonText: window.I18n.t('js.buttons.cancel')
      }, function(confirmed) {
        if (confirmed) {
          var path = window.hrefDirty;
          window.app.clearDirty();
          window.Turbolinks.visit(path);
        }
      });
    }
  });
});
