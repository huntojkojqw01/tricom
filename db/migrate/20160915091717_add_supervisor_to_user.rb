class AddSupervisorToUser < ActiveRecord::Migration
  def change
    add_column :担当者マスタ, :supervisor, :boolean, default: false
  end
end
