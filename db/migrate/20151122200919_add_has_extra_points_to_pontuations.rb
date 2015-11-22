class AddHasExtraPointsToPontuations < ActiveRecord::Migration
  def change
    add_column :pontuations, :has_extra_points, :boolean, null: false, default: false
  end
end
