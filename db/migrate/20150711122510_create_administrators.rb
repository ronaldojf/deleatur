class CreateAdministrators < ActiveRecord::Migration
  def change
    create_table :administrators do |t|
      t.string :name
      t.boolean :main, null: false, default: false

      t.timestamps null: false
    end
  end
end
