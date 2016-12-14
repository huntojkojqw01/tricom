class AddRepassword < ActiveRecord::Migration
  def up
    add_column :担当者マスタ, :再パスワード, :string
  end

  def down
    remove_column :担当者マスタ, :再パスワード, :string
  end
end
