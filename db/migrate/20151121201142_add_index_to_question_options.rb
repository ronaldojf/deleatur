class AddIndexToQuestionOptions < ActiveRecord::Migration
  def change
    add_column :question_options, :index, :integer, null: false, default: 0
  end
end
