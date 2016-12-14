class AddHolidayMarkToKintais < ActiveRecord::Migration
  def change
    add_column :kintais, :holiday, :string
  end
end
