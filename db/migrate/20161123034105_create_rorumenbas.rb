class CreateRorumenbas < ActiveRecord::Migration
  def change
    create_table :ロールメンバ, id:false do |t|
      t.string :ロールコード
      t.string :社員番号
      t.text :氏名,:limit => 30
      t.string :ロール内序列, :limit =>10
      t.timestamps null: false
    end
    add_index :ロールメンバ, [:社員番号,:ロールコード], unique: true
  end
end
