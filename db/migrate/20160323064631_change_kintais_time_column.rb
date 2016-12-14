class ChangeKintaisTimeColumn < ActiveRecord::Migration
  def up
    remove_column :kintais, :出勤時刻
    remove_column :kintais, :退社時刻
    add_column :kintais, :出勤時刻, :datetime
    add_column :kintais, :退社時刻, :datetime
  end

  def down
    remove_column :kintais, :出勤時刻
    remove_column :kintais, :退社時刻
    add_column :kintais, :出勤時刻, :time
    add_column :kintais, :退社時刻, :time
  end
end