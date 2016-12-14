class CreateDengons < ActiveRecord::Migration
  def change
    create_table :伝言 do |t|
      t.string :from1
      t.string :from2
      t.datetime :日付
      t.string :入力者
      t.string :to
      t.string :用件
      t.string :回答
      t.string :伝言内容
      t.boolean :確認
      t.boolean :送信

      t.timestamps null: false
    end
  end
end
