class RemovePointsFromAnsweredQuestionnaires < ActiveRecord::Migration
  def change
    remove_column :answered_questionnaires, :points, :decimal, precision: 15, scale: 10, null: false, default: 0.0
  end
end
