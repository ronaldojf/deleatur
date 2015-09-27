window.deleatur
  .controller('TeachController', ['$scope', function($scope) {
    $scope.teacher = {};
    $scope.classrooms = [];
    $scope.subjects = [];

    $scope.addClassroomSubject = function(classroom, subject) {
      if (!classroom || !subject) { return; }

      $scope.classroomsSubjects.push({
        subject_id: subject.id,
        classroom_id: classroom.id,
        description: subject.description,
        identifier: classroom.identifier,
      });

      $scope.classroomsSubjects = $scope.removeRepeated($scope.classroomsSubjects);
    };

    $scope.removeClassroomSubject = function(selectedItem) {
      $scope.classroomsSubjects = $scope.classroomsSubjects.filter(function(item, i) {
        if (!(item.subject_id === selectedItem.subject_id && item.classroom_id === selectedItem.classroom_id)) {
          return true;
        } else if (item.id) {
          item._destroy = 1;
          return true;
        }
        else {
          return false;
        }
      });
    };

    $scope.removeRepeated = function(collection) {
      var newCollection = [];

      collection.forEach(function(mainObject) {
        newCollection.push(mainObject);

        var matches = newCollection.filter(function(object) {
          return mainObject.subject_id === object.subject_id && mainObject.classroom_id === object.classroom_id;
        });

        if ((matches[0] || {})._destroy === 1 || (matches[1] || {})._destroy === 1) {
          delete newCollection[newCollection.length-1]._destroy;
        } else if (matches.length > 1) {
          newCollection.pop();
        }
      });

      return newCollection;
    };
  }]);
