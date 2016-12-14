class ChangeTypeOfOrderShainmaster < ActiveRecord::Migration
  def change
    remove_column :社員マスタ, :序列, :string
    add_column :社員マスタ, :序列, :integer, default: 0
  end
end
