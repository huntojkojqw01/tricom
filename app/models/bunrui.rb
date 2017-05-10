class Bunrui < ActiveRecord::Base
  self.table_name = :分類マスタ
  self.primary_key = :分類コード
  include PgSearch
  multisearchable :against => %w{分類コード 分類名}
  validates :分類コード, uniqueness: true
  validates :分類コード, :分類名, presence: true

  has_one :jobmaster, foreign_key: :分類コード, dependent: :nullify
  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      Bunrui.create! row.to_hash
    end
  end

  def self.to_csv
    attributes = %w{分類コード 分類名}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |user|
        csv << attributes.map{ |attr| user.send(attr) }
      end
    end
  end
  # Naive approach
  def self.rebuild_pg_search_documents
    find_each { |record| record.update_pg_search_document }
  end
end
