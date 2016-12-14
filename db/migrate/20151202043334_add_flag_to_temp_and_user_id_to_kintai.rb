class AddFlagToTempAndUserIdToKintai < ActiveRecord::Migration
  def change
    add_column :kintais, :社員番号, :string
    add_column :kintais, :入力済, :string
  end
end
