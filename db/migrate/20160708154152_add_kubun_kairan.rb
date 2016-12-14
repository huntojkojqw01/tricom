class AddKubunKairan < ActiveRecord::Migration
  def up
    add_column :回覧, :確認要, :boolean
    add_column :回覧, :確認済, :boolean
  end

  def down
    remove_column :回覧, :確認要, :boolean
    remove_column :回覧, :確認済, :boolean
  end
end
