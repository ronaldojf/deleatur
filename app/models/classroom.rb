class Classroom < ActiveRecord::Base
  include Utils::Filtering
  has_many :teachers_subjects, class_name: 'TeacherClassroomSubject', dependent: :destroy

  validates :identifier, presence: true, uniqueness: { case_sensitive: false }
  filtering :identifier
end
