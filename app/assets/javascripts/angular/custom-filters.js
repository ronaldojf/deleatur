window.angular.module('deleatur.filters', [])
  .filter("sum", function() {
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
  });