class ChangeColumnKairan < ActiveRecord::Migration
  def up
    remove_column :回覧詳細, :確認, :boolean
    remove_column :回覧詳細, :回答済, :boolean
    add_column :回覧詳細, :状態, :integer
  end
  def down
  end
end
