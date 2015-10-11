class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.references :question_option, index: true, foreign_key: true
      t.references :answered_questionnaire, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
