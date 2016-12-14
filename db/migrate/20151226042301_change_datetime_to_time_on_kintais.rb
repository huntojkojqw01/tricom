class ChangeDatetimeToTimeOnKintais < ActiveRecord::Migration
  def up
    change_column :kintais, :出勤時刻, :time
    change_column :kintais, :退社時刻, :time
  end
  def down

  end
end
