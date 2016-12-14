class Temp < ActiveRecord::Migration
  def up
    remove_column :kintais, :遅刻時間
    remove_column :kintais, :早退時間
    add_column :kintais, :遅刻時間, :decimal
    add_column :kintais, :早退時間, :decimal
  end

  def down
    remove_column :kintais, :遅刻時間
    remove_column :kintais, :早退時間
    add_column :kintais, :遅刻時間, :time
    add_column :kintais, :早退時間, :time
  end
end
