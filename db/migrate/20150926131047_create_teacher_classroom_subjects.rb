class CreateTeacherClassroomSubjects < ActiveRecord::Migration
  def change
    create_table :teacher_classroom_subjects do |t|
      t.references :classroom, index: true, foreign_key: true
      t.references :teacher, index: true, foreign_key: true
      t.references :subject, index: true, foreign_key: true
    end
  end
end
