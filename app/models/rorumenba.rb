class Rorumenba < ActiveRecord::Base
	self.table_name = :ロールメンバ
	self.primary_keys = :ロールコード, :社員番号
  include PgSearch
  multisearchable :against => %w{ロールコード 社員番号 氏名 ロール内序列}
  validates :ロールコード,:社員番号, presence: true
  validates :ロール内序列, length: {maximum: 10}
	belongs_to :shainmaster, foreign_key: :社員番号
	belongs_to :rorumaster, foreign_key: :ロールコード

  def self.import(file)

    # a block that runs through a loop in our CSV data
    CSV.foreach(file.path, headers: true) do |row|
      # creates a user for each row in the CSV file
      Rorumenba.create! row.to_hash
    end
  end

  def self.to_csv
    attributes = %w{ロールコード 社員番号 氏名 ロール内序列}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |rorumenba|
        csv << attributes.map{ |attr| rorumenba.send(attr) }
      end
    end
  end
  # Naive approach
  def self.rebuild_pg_search_documents
    find_each { |record| record.update_pg_search_document }
  end
end
