class CreateDengonyoukens < ActiveRecord::Migration
  def change
    create_table :伝言用件マスタ do |t|
      t.string :種類名
      t.string :備考

      t.timestamps null: false
    end
  end
end
