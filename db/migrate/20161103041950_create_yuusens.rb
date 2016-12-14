class CreateYuusens < ActiveRecord::Migration
  def change
    create_table :優先 do |t|
      t.integer :優先さ
      t.string :名前
      t.string :色

      t.timestamps null: false
    end
  end
end
