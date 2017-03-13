class AddSetholidayToSettingtable < ActiveRecord::Migration[5.0]
  def change
    add_column :setting_tables, :select_holiday_vn, :string
  end
end
