class AddKubunKairanShoshai < ActiveRecord::Migration
  def up
    add_column :回覧詳細, :回答済, :boolean
  end

  def down
    remove_column :回覧詳細, :回答済, :boolean
  end
end
