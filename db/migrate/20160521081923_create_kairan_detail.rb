class CreateKairanDetail < ActiveRecord::Migration
  def change
    create_table :回覧詳細 do |t|
      t.string :回覧コード
      t.string :対象者

      t.timestamps null: false
    end
  end
end
