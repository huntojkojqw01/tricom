class Yuusen < ActiveRecord::Base
	self.table_name = :優先
	self.primary_key = :優先さ
  include PgSearch
  multisearchable :against => %w{優先さ 備考 色}
  validates :優先さ, presence: true
  validates :優先さ, uniqueness: true
	has_many :kairanyokenmsts, foreign_key: :優先さ
	has_many :dengonyokens, foreign_key: :優先さ

  def self.import(file)
    # a block that runs through a loop in our CSV data
    CSV.foreach(file.path, headers: true) do |row|
      # creates a user for each row in the CSV file
      Yuusen.create! row.to_hash
    end
  end

  def self.to_csv
    attributes = %w{優先さ 備考 色}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |yuusen|
        csv << attributes.map{ |attr| yuusen.send(attr) }
      end
    end
  end
  # Naive approach
  def self.rebuild_pg_search_documents
    find_each { |record| record.update_pg_search_document }
  end
end

