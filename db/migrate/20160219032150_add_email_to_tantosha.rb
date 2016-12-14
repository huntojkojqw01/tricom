class AddEmailToTantosha < ActiveRecord::Migration
  def up
    add_column :担当者マスタ, :email, :string
  end

  def down
    remove_column :担当者マスタ, :email
  end
end
