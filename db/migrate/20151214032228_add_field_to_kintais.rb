class AddFieldToKintais < ActiveRecord::Migration
  def change
    add_column :kintais, :代休相手日付, :date
    add_column :kintais, :代休取得区分, :string
  end
end
