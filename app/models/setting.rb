class Setting < ActiveRecord::Base
  self.table_name = :setting_tables
  self.primary_keys =  :社員番号
  include PgSearch
  multisearchable :against => %w{社員番号 scrolltime local}
  validates :社員番号, presence: true
  validates :社員番号, uniqueness: true
  belongs_to :shainmaster, foreign_key: :社員番号

  def self.import(file)

    # a block that runs through a loop in our CSV data
    CSV.foreach(file.path, headers: true) do |row|
      # creates a user for each row in the CSV file
      Setting.create! row.to_hash
    end
  end

  def self.to_csv
    attributes = %w{社員番号 scrolltime local}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |setting|
        csv << attributes.map{ |attr| setting.send(attr) }
      end
    end
  end
  # Naive approach
  def self.rebuild_pg_search_documents
    find_each { |record| record.update_pg_search_document }
  end
end
