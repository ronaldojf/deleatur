class CreateAnsweredQuestionnaires < ActiveRecord::Migration
  def change
    create_table :answered_questionnaires do |t|
      t.integer :status, null: false, default: 0
      t.decimal :points, precision: 15, scale: 10, null: false, default: 0.0
      t.references :questionnaire, index: true, foreign_key: true
      t.references :student, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
