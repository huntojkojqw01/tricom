class ChangeColumnToNewFromKintaiteeburu < ActiveRecord::Migration[5.0]
  def change
    change_column :kintaiteeburus, :出勤時刻, :string
    change_column :kintaiteeburus, :退社時刻, :string
  end
end
