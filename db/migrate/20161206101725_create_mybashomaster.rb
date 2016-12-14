class CreateMybashomaster < ActiveRecord::Migration
  def change
    create_table :MY場所マスタ, id:false do |t|
      t.string :社員番号, null:false
      t.string :場所コード, null: false
      t.string :場所名
      t.string :場所名カナ
      t.string :SUB
      t.string :場所区分
      t.string :会社コード
      t.datetime :更新日

      t.timestamps null: false
    end
  end
end
