class CreateClassroomsSubjectsJoinTable < ActiveRecord::Migration
  def change
    create_join_table :classrooms, :subjects
  end
end
