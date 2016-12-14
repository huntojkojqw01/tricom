class AddRemainDayToShainmst < ActiveRecord::Migration
  def up
    add_column :社員マスタ, :有給残数, :decimal
  end

  def down
    remove_column :社員マスタ, :有給残数
  end
end
