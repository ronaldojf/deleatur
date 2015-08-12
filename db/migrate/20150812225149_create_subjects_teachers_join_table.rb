class CreateSubjectsTeachersJoinTable < ActiveRecord::Migration
  def change
    create_join_table :subjects, :teachers
  end
end
