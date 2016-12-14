class CreateSetsubi < ActiveRecord::Migration
  def change
    create_table :設備マスタ do |t|
      t.string :設備コード
      t.string :設備名
      t.string :備考

      t.timestamps null: false
    end
  end
end
