class TeacherClassroomSubject < ActiveRecord::Base
  belongs_to :teacher
  belongs_to :classroom
  belongs_to :subject

  validates :teacher, :classroom, :subject, presence: true
end
