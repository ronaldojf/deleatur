window.angular.module('deleatur.filters', [])
  .filter('debug', [function() {
    return function(str) {
        console.log('debug', str);
        return str;
      };
    }
  ])
  .filter('format', [function() {
    return function(str) {
        if (!str || arguments.length <= 1) { return str; }
        var args = arguments;
        for (var i = 1; i < arguments.length; i++) {
          var reg = new RegExp('\\{' + (i - 1) + '\\}', 'gm');
          str = str.replace(reg, arguments[i]);
        }
        return str;
      };
    }
  ])
  .filter('html2string', [function() {
    return function(str) {
        if (!str) { return str; }
        return $('<div/>').html(str).text();
      };
    }
  ])
  .filter('truncate', [function() {
    return function(str,length) {
        if (!str || !length || str.length <= length) { return (str || ''); }
        return str.substr(0, length) + (length <= 3 ? '' : '...');
      };
    }
  ])
  .filter('lowercase', [function() {
    return function(str) {
        return (str || '').toLowerCase();
      };
    }
  ])
  .filter('uppercase', [function() {
    return function(str) {
        return (str || '').toUpperCase();
      };
    }
  ])
  .filter('camelcase', [function() {
   return function(str) {
      return (str || '').toLowerCase().replace(/(\s.|^.)/g, function(match, group) {
        return group ? group.toUpperCase() : '';
      });
    };
   }
  ])
  .filter('trim', [function() {
   return function(str) {
      return (str || '').replace(/(^\s*|\s*$)/g, function() {
          return '';
      });
    };
   }
  ])
  .filter('trimstart', [function() {
    return function(str) {
     return (str || '').replace(/(^\s*)/g, function() {
          return '';
      });
    };
   }
  ])
  .filter('trimend', [function() {
    return function(str) {
      return (str || '').replace(/(\s*$)/g, function() {
          return '';
      });
    };
   }
  ])
  .filter('replace', [function() {
    return function(str, pattern, replacement) {
      try {
        return (str || '').replace(pattern,replacement);
      } catch(e) {
        console.error('error in string.replace', e);
        return (str || '');
      }
    };
   }
  ])
  .filter('max', [function() {
    return function(arr) {
      if (!arr) { return arr; }
      return Math.max.apply(null, arr);
    }
   }
  ])
  .filter('min', [function() {
    return function(arr) {
      if (!arr) { return arr; }
      return Math.min.apply(null, arr);
    };
   }
  ])
  .filter('sum', function() {
    return function(items, attribute) {
      var count = 0;

      if (attribute) {
        for (var i = 0; i < items.length; i++) {
          count += parseFloat(items[i][attribute]);
        }
      } else {
        for (var i = 0; i < items.length; i++) {
          count += parseFloat(items[i]);
        }
      }

      return count;
    };
  })
  .filter('percent', function() {
    return function(value, total) {
      if (value && total) {
        return (value*100) / total;
      } else {
        return 0;
      }
    };
  })
  .filter('join', [function() {
    return function(arr, separator) {
      if (!arr) { return arr; }
      return arr.join(separator || ',');
    };
   }
  ])
  .filter('reverse', [function() {
    return function(arr) {
      if (!arr) { return arr; }
      return arr.reverse();
    };
   }
  ])
  .filter('keys', function() {
    return function(obj) {
      if (obj) {
        return Object.keys(obj);
      } else {
        return [];
      }
    };
  })
  .filter('values', function() {
    return function(obj) {
      if (obj) {
        return Object.keys(obj).map(function(key) {
          return obj[key];
        });
      } else {
        return [];
      }
    };
  })
  .filter('t', function() {
    return function(scope, options) {
      options = options || {};
      options.scope = options.scope || [];
      options.scope = Array.isArray(options.scope) ? options.scope : options.scope.split('.');
      options.scope.unshift('js');
      options.scope = options.scope.join('.');

      return window.I18n.t(String(scope), options || {});
    };
  });