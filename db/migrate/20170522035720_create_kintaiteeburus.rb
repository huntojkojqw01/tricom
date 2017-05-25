class CreateKintaiteeburus < ActiveRecord::Migration[5.0]
  def change
    create_table :kintaiteeburus do |t|
      t.string :勤務タイプ
      t.time :出勤時刻
      t.time :退社時刻
      t.float :昼休憩時間
      t.float :夜休憩時間
      t.float :深夜休憩時間
      t.float :早朝休憩時間
      t.float :実労働時間
      t.float :早朝残業時間
      t.float :残業時間
      t.float :深夜残業時間

      t.timestamps
    end
  end
end
