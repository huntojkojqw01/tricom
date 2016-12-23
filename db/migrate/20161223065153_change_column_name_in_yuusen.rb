class ChangeColumnNameInYuusen < ActiveRecord::Migration[5.0]
  def change
    rename_column :優先, :名前, :備考
  end
end
