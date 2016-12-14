class AddKubunToShainmaster < ActiveRecord::Migration
  def change
    add_column :社員マスタ, :区分, :boolean, default: true
  end
end
