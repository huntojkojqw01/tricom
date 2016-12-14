class CreateSettingTable < ActiveRecord::Migration
  def change
    create_table :setting_tables do |t|
      t.string :社員番号, null:false
      t.string :scrolltime

      t.timestamps null: false
    end
  end
end
