class Subject < ActiveRecord::Base
  include Utils::Filtering
  has_many :classrooms_teachers, class_name: 'TeacherClassroomSubject', dependent: :destroy
  has_many :questionnaires

  validates :description, presence: true, uniqueness: { case_sensitive: false }
  filtering :description

  scope :for_classroom, -> (classroom) {
    joins(:classrooms_teachers)
    .where(classrooms_teachers: {classroom_id: classroom.try(:id) || classroom}) if classroom.present?
  }
end
