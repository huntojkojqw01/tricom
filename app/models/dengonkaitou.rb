class Dengonkaitou < ActiveRecord::Base
  self.table_name = :伝言回答マスタ
  include PgSearch
  multisearchable :against => %w{種類名 備考}
  validates :種類名, presence: true

  # a class method import, with file passed through as an argument

  def self.import(file)
    # a block that runs through a loop in our CSV data
    CSV.foreach(file.path, headers: true) do |row|
      # creates a user for each row in the CSV file
      Dengonkaitou.create! row.to_hash
    end
  end


  def self.to_csv
    attributes = %w{id 種類名 備考}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |dengonkaitou|
        csv << attributes.map{ |attr| dengonkaitou.send(attr) }
      end
    end
  end
  # Naive approach
  def self.rebuild_pg_search_documents
    find_each { |record| record.update_pg_search_document }
  end
end
