class CreateMykaishamaster < ActiveRecord::Migration[5.0]
  def change
    create_table :MY会社マスタ, id: false, force: :cascade do |t|
      t.string :社員番号, null:false
      t.string :会社コード,      null: false
      t.string :会社名
      t.text :備考
    end
  end
end
