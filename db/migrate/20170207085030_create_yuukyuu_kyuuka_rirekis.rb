class CreateYuukyuuKyuukaRirekis < ActiveRecord::Migration[5.0]
  def change
    create_table :有給休暇履歴 do |t|
      t.string :社員番号,  :limit => 10, null:false
      t.string :年月, :limit => 10, null:false
      t.float :月初有給残
      t.float :月末有給残

      t.timestamps
    end
  end
end
