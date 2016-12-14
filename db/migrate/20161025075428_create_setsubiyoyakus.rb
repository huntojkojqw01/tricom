class CreateSetsubiyoyakus < ActiveRecord::Migration
  def change
    create_table :設備予約 do |t|
      t.string :設備コード
      t.string :予約者
      t.string :相手先
      t.string :開始
      t.string :終了
      t.text :用件

      t.timestamps null: false
    end
  end
end
