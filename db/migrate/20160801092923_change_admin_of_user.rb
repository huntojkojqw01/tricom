class ChangeAdminOfUser < ActiveRecord::Migration
  def change
    change_column :担当者マスタ, :admin, :boolean, default: false
  end
end
