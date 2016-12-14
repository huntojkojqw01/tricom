class AddLoginTimeToShainmaster < ActiveRecord::Migration
  def change
    add_column :社員マスタ, :login_time, :date
  end
end
