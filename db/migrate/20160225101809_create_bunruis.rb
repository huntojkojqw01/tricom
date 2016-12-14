class CreateBunruis < ActiveRecord::Migration
  def change
    create_table :分類マスタ, id: false do |t|
      t.string :分類コード, null: false
      t.string :分類名

      t.timestamps null: false
    end

    add_index :分類マスタ, :分類コード, unique: true
  end
end
