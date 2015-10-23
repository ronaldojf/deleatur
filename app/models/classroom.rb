class Classroom < ActiveRecord::Base
  include Utils::Filtering
  has_many :teachers_subjects, class_name: 'TeacherClassroomSubject'
  has_many :teachers, -> { uniq }, through: :teachers_subjects
  has_many :students
  has_many :questionnaires

  validates :identifier, presence: true, uniqueness: { case_sensitive: false }
  filtering :identifier

  def destroy
    super if !self.teachers_subjects.exists? && !self.students.exists? && !self.questionnaires.exists?
  end
end
