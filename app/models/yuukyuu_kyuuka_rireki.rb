class YuukyuuKyuukaRireki < ActiveRecord::Base
  self.table_name = :有給休暇履歴
  self.primary_key = :社員番号, :年月

  belongs_to :shainmaster, foreign_key: :社員番号

end
