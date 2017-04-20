class ChangeKinmutypeToKaishamaster < ActiveRecord::Migration[5.0]
  def change
  	change_column_default :社員マスタ, :勤務タイプ, from: nil, to: '005'
  end
end
