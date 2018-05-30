class AddColumnToJoutaimaster < ActiveRecord::Migration[5.0]
  def change
    add_column :状態マスタ, :残業計算外区分, :string
  end
end
