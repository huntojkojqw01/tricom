class AddIndexToYuukyuuKyuukaRirekis < ActiveRecord::Migration[5.0]
  def change
    add_index :有給休暇履歴, [:社員番号, :年月], :unique => true
  end
end
