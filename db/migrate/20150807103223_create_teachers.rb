class CreateTeachers < ActiveRecord::Migration
  def change
    create_table :teachers do |t|
      t.string :name
      t.integer :gender, null: false, default: Teacher.genders[:male]
      t.string :email
      t.string :cpf
      t.string :phone
      t.date :birth_date
      t.integer :status, null: false, default: Teacher.statuses[:pending]

      t.timestamps null: false
    end
  end
end
