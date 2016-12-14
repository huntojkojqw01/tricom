class CreateKairans < ActiveRecord::Migration
  def change
    create_table :回覧 do |t|
      t.string :発行者
      t.string :要件
      t.datetime :開始
      t.datetime :終了
      t.string :件名
      t.text :内容
      t.boolean :確認
      t.timestamps null: false
    end
  end
end
