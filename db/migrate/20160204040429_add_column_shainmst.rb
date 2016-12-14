class AddColumnShainmst < ActiveRecord::Migration
  def up
    add_column :社員マスタ, :残業区分, :string
    add_column :社員マスタ, :勤務タイプ, :string
  end
  def down
    remove_column :社員マスタ, :残業区分
    remove_column :社員マスタ, :勤務タイプ
  end
end
