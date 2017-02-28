class FixColumnName < ActiveRecord::Migration[5.0]
  def self.up
    rename_column :paths, :model_name, :model_name_field
  end

  def self.down
    rename_column :paths, :model_name_field, :model_name
  end
end
