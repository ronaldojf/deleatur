$(function() {
  window.Turbolinks.enableProgressBar();

  window.App = function() {
    this.defaults();
    this.binds();
  };

  window.App.prototype.markDirty = function() {
    if (!window._isDirty) {
      $(window).bind('beforeunload', function(e){
        var message = window.I18n.t('js.forms.unsaved.default');

        e = e || window.event;
        e.returnValue = message;
      });
    }
    window._isDirty = true;
  };

  window.App.prototype.clearDirty = function() {
    window._isDirty = false;
    window.hrefDirty = undefined;
    $(window).unbind('beforeunload');
  };

  window.App.prototype.binds = function() {
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
  };

  window.App.prototype.defaults = function() {
    swal.setDefaults({
      confirmButtonColor: '#1ab394',
      cancelButtonColor: '#f3f3f4',
      confirmButtonText: window.I18n.t('js.buttons.ok'),
      cancelButtonText: window.I18n.t('js.buttons.cancel')
    });
  };
});
