class ChangeTypeOfKintaiKeitaikaisu < ActiveRecord::Migration
  def change
    change_column :kintais, :保守携帯回数, 'integer USING CAST(保守携帯回数 AS integer)'
  end
end
