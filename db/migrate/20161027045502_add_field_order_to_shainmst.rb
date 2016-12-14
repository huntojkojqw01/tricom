class AddFieldOrderToShainmst < ActiveRecord::Migration
  def up
    add_column :社員マスタ, :序列, :string
  end
  def down
    remove_column :社員マスタ, :序列
  end
end