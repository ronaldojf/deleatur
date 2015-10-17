class CreatePontuations < ActiveRecord::Migration
  def change
    create_table :pontuations do |t|
      t.decimal :points, precision: 15, scale: 5, null: false, default: 0.0
      t.references :answered_questionnaire, index: true, foreign_key: true
      t.references :student, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
