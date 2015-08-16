class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :name
      t.integer :gender, null: false, default: Student.genders[:male]
      t.string :email
      t.string :cpf
      t.string :phone
      t.date :birth_date
      t.references :classroom, index: true
      t.integer :status, null: false, default: Student.statuses[:normal]

      t.timestamps null: false
    end

    add_foreign_key :students, :classrooms
  end
end
