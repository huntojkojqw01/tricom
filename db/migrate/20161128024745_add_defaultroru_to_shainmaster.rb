class AddDefaultroruToShainmaster < ActiveRecord::Migration
  def change
    add_column :社員マスタ, :デフォルトロール, :string
  end
end
