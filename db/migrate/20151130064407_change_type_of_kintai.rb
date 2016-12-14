class ChangeTypeOfKintai < ActiveRecord::Migration
  def change
      change_column :kintais, :実労働時間, 'decimal USING CAST(実労働時間 AS decimal)'
      change_column :kintais, :遅刻時間, 'decimal USING CAST(遅刻時間 AS decimal)'
      change_column :kintais, :早退時間, 'decimal USING CAST(早退時間 AS decimal)'
      change_column :kintais, :普通残業時間, 'decimal USING CAST(普通残業時間 AS decimal)'
      change_column :kintais, :深夜残業時間, 'decimal USING CAST(深夜残業時間 AS decimal)'
      change_column :kintais, :普通保守時間, 'decimal USING CAST(普通保守時間 AS decimal)'
      change_column :kintais, :深夜保守時間, 'decimal USING CAST(深夜保守時間 AS decimal)'
  end
end
