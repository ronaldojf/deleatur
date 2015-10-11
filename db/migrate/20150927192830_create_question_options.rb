class CreateQuestionOptions < ActiveRecord::Migration
  def change
    create_table :question_options do |t|
      t.text :description
      t.boolean :right, null: false, default: false
      t.references :question, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
