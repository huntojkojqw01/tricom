class CreateDengonkaitous < ActiveRecord::Migration
  def change
    create_table :伝言回答マスタ do |t|
      t.string :種類名
      t.string :備考

      t.timestamps null: false
    end
  end
end
