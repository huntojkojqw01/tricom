class Kairan < ActiveRecord::Base
  self.table_name = :回覧
  include PgSearch
  multisearchable :against => %w{氏名 名称 件名 内容}
  belongs_to :kairanyokenmst, foreign_key: :要件
  belongs_to :shainmaster, foreign_key: :発行者

  # has_many :kairanshosais, dependent: :destroy
  has_many :kairanshosais, dependent: :destroy, foreign_key: :回覧コード

  # delegate :要件名, to: :kairanyokenmst, prefix: :job, allow_nil: true
  delegate :名称, to: :kairanyokenmst, allow_nil: true
  delegate :氏名, to: :shainmaster, allow_nil: true


  def self.to_csv
    attributes = %w{id 発行者 要件 開始 終了 件名 内容 確認 確認要 確認済}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |kairan|
        csv << attributes.map{ |attr| kairan.send(attr) }
      end
    end
  end
  # Naive approach
  def self.rebuild_pg_search_documents
    find_each { |record| record.update_pg_search_document }
  end
end
