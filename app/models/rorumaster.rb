class Rorumaster < ActiveRecord::Base
	self.table_name = :ロールマスタ
	self.primary_key = :ロールコード
  include PgSearch
  multisearchable :against => %w{ロールコード ロール名 序列}
  validates :ロールコード,:ロール名, presence: true
  validates :ロールコード, uniqueness: true
  validates :ロールコード, length: {maximum: 10}
  validates :ロール名, length: {maximum: 40}
  validates :序列, length: {maximum: 10}
	has_many :rorumenba, dependent: :destroy, foreign_key: :ロールコード
  has_many :shainmasters, foreign_key: :ロールコード

  def self.import(file)

    # a block that runs through a loop in our CSV data
    CSV.foreach(file.path, headers: true) do |row|
      # creates a user for each row in the CSV file
      Rorumaster.create! row.to_hash
    end
  end

  def self.to_csv
    attributes = %w{ロールコード ロール名 序列}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |rorumaster|
        csv << attributes.map{ |attr| rorumaster.send(attr) }
      end
    end
  end
  # Naive approach
  def self.rebuild_pg_search_documents
    find_each { |record| record.update_pg_search_document }
  end
end
