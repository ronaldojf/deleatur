class DropUselessJoinTables < ActiveRecord::Migration
  def change
    drop_join_table :subjects, :teachers
    drop_join_table :classrooms, :teachers
    drop_join_table :classrooms, :subjects
  end
end
