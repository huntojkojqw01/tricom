class Mykaishamaster < ActiveRecord::Base
  self.table_name = :MY会社マスタ
  self.primary_key = :会社コード, :社員番号

  validates :社員番号,:会社コード, :会社名, presence: true
  validates :会社コード, uniqueness: {scope: :社員番号}

  belongs_to :shainmaster, foreign_key: :社員番号
  belongs_to :kaishamaster, foreign_key: :会社コード
end
