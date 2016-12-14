class AddFlagCheckedToKairanShoshai < ActiveRecord::Migration
  def up
    add_column :回覧詳細, :確認, :boolean
  end

  def down
    remove_column :回覧詳細, :確認, :boolean
  end
end
