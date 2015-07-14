$(function() {
  Turbolinks.enableProgressBar();

  window.App = function() {
    this.binds();
  };

  App.prototype.markDirty = function() {
    if (!window._isDirty) {
      $(window).bind("beforeunload", function(e){
        var message = I18n.t('js.forms.unsaved.default');

        e = e || window.event;
        e.returnValue = message;
      });
    }
    window._isDirty = true;
  }

  App.prototype.clearDirty = function() {
    window._isDirty = false;
    window.hrefDirty = undefined;
    $(window).unbind("beforeunload");
  }

  App.prototype.binds = function() {
    $("[data-toggle=tooltip]").on("click", function(e) {
      e.preventDefault();
    }).tooltip();

    $("[data-form-submit]").on("click", function(e) {
      var form = $($(this).data("form-submit"));

      if (form.find("input[type='submit']").length > 0) {
        form.find("input[type='submit']").click();
      } else {
        form.submit();
      }

      e.preventDefault();
    });

    $("body").on("click", "tr[data-href] td:not([data-no-href])", function(e) {
      Turbolinks.visit($(this).parents("tr:first").data("href"));
    });

    setTimeout(function() {
      $("[autofocus]:first").focus();
    }, 500);
  }

  $(document).on("page:change", function() {
    window.app = new window.App();

    $("div.form form *").on("change", function() {
      app.markDirty();
    });

    $("a[href^='/']").on("click", function(e) {
      if (window._isDirty) {
        window.hrefDirty = $(e.target).attr('href');
      }
    });

    $("div.form form").on("submit", function() {
      app.clearDirty();
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
        Turbolinks.visit(link.attr('href'));
      }
    };

    $.rails.showConfirmDialog = function(link) {
      message = link.attr('data-confirm');
      swal({
        title: I18n.t('js.messages.titles.sure'),
        text: message,
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: "#1ab394",
        cancelButtonColor: "#f3f3f4",
        confirmButtonText: I18n.t('js.buttons.ok'),
        cancelButtonText: I18n.t('js.buttons.cancel')
      });
      $('.sweet-alert .confirm').on('click', function() { $.rails.confirmed(link) });
    };
  });

  $(document).on("page:before-change", function(e) {
    if (window._isDirty && window.hrefDirty) {
      e.preventDefault();
      swal({
        title: I18n.t('js.messages.titles.sure'),
        text: I18n.t('js.forms.unsaved.quit'),
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: "#1ab394",
        cancelButtonColor: "#f3f3f4",
        confirmButtonText: I18n.t('js.buttons.ok'),
        cancelButtonText: I18n.t('js.buttons.cancel')
      }, function(confirmed) {
        if (confirmed) {
          app.clearDirty();
          Turbolinks.visit(window.hrefDirty);
        }
      });
    }
  });
});
