class Subject < ActiveRecord::Base
  include Utils::Filtering
  has_many :classrooms_teachers, class_name: 'TeacherClassroomSubject', dependent: :destroy

  validates :description, presence: true, uniqueness: { case_sensitive: false }
  filtering :description
end
