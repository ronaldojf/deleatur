window.deleatur
  .controller('QuestionnaireRegistrationController', ['$scope', '$timeout', '$filter', function($scope, $timeout, $filter) {
    $scope.questionnaire = {questions: []};
    $scope.sortableOptions = {
      handle: '.drag-handler',
      connectWith: '.drag-item',
      tolerance: 'pointer',
      forcePlaceholderSize: true,
      opacity: 0.8,
    };
    $scope.summernoteOptions = {
      lang: 'pt-BR',
      onFocus: function() {
        $('.note-dialog').parents().removeClass('animated');
      },
      toolbar: [
        ['edit', ['undo', 'redo']],
        ['headline', ['style']],
        ['style', ['bold', 'italic', 'underline', 'superscript', 'subscript', 'strikethrough', 'clear']],
        ['fontface', ['fontname']],
        ['textsize', ['fontsize']],
        ['alignment', ['ul', 'ol', 'paragraph', 'lineheight']],
        ['height', ['height']],
        ['table', ['table']],
        ['insert', ['hr']],
        ['view', ['codeview']],
        ['help', ['help']]
      ]
    };

    $scope.initClassroomSubject = function() {
      $scope.questionnaire.classroom_subject = ($scope.classrooms_subjects || []).filter(function(item) {
        return $scope.questionnaire.classroom_id === item.classroom_id && $scope.questionnaire.subject_id === item.subject_id;
      })[0];
    };

    $scope.addQuestion = function() {
      $scope.questionnaire.questions.push({ options: [{}] });
      $timeout(function() {
        window.refreshIBox();
      });
    };

    $scope.addOptionTo = function(question) {
      question.options.push({});
      $timeout(function() {
        window.refreshIBox();
      });
    };

    $scope.removeQuestion = function(index) {
      $scope.baseSliceRemove(index, $scope.questionnaire.questions);
    };

    $scope.removeOption = function(index, question) {
      if ($scope.notDestroyed(question.options).length > 1) {
        $scope.baseSliceRemove(index, question.options);
      }
    };

    $scope.baseSliceRemove = function(index, collection) {
      if (!$scope.notDestroyed(collection)[index].description) {
        $scope.sliceOrMarkForDestruction(index, collection);
      } else {
        window.swal({
          title: window.I18n.t('js.messages.titles.sure'),
          type: 'warning',
          showCancelButton: true
        }, function(confirmed) {
          if (confirmed) {
            $timeout(function() {
              $scope.sliceOrMarkForDestruction(index, collection);
            });
          }
        });
      }
    };

    $scope.sliceOrMarkForDestruction = function(index, collection) {
      var notDestroyedCollection = $scope.notDestroyed(collection);

      if (notDestroyedCollection[index] && notDestroyedCollection[index].id) {
        notDestroyedCollection[index]._destroy = 1;
      } else {
        notDestroyedCollection[index]._sliced = 1;
      }
    };

    $scope.notDestroyed = function(collection) {
      return collection.filter(function(item) {
        return item._destroy !== 1 && item._sliced !== 1;
      });
    };

    $scope.notSliced = function(collection) {
      return collection.filter(function(item) {
        return item._sliced !== 1;
      });
    };
  }]);
