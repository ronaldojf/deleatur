class CreateClassroomsTeachersJoinTable < ActiveRecord::Migration
  def change
    create_join_table :classrooms, :teachers
  end
end
