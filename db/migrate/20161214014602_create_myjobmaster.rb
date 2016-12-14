class CreateMyjobmaster < ActiveRecord::Migration
  def change
    create_table :MYJOBマスタ, id: false, force: :cascade do |t|
      t.string :社員番号, null:false
      t.string :job番号,      null: false
      t.string :job名
      t.date :開始日
      t.date :終了日
      t.string :ユーザ番号
      t.string :ユーザ名
      t.string :入力社員番号
      t.string :分類コード
      t.string :分類名
      t.string :関連Job番号
      t.string :備考
      end
  end
end
