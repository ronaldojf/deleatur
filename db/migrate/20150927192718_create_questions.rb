class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :description
      t.integer :index, null: false, default: 0
      t.references :questionnaire, index: true, foreign_key: true
      t.integer :question_options_count

      t.timestamps null: false
    end
  end
end
