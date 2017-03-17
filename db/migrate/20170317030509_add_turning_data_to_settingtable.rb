class AddTurningDataToSettingtable < ActiveRecord::Migration[5.0]
  def change
    add_column :setting_tables, :turning_data, :boolean
  end
end
