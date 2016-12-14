class CreateTsushinseigyous < ActiveRecord::Migration
  def change
    create_table :通信制御マスタ do |t|
      t.string :社員番号
      t.string :メール
      t.string :送信許可区分

      t.timestamps null: false
    end
  end
end
