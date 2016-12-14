class AddSetlocalToSettingtable < ActiveRecord::Migration
  def change
    add_column :setting_tables, :local, :string
  end
end
