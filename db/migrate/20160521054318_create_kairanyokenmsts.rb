class CreateKairanyokenmsts < ActiveRecord::Migration
  def change
    create_table :回覧用件マスタ do |t|
      t.string :名称
      t.string :備考

      t.timestamps null: false
    end
  end
end
