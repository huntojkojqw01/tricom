class ChangeColumnUser < ActiveRecord::Migration
  def up
    remove_column :担当者マスタ, :パスワード, :string
    remove_column :担当者マスタ, :再パスワード, :string
    add_column :担当者マスタ, :password_digest, :string
    add_column :担当者マスタ, :remember_digest, :string
  end
  def down
  end
end
