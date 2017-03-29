class Dengonyouken < ActiveRecord::Base
  self.table_name = :伝言用件マスタ
  include PgSearch
  multisearchable :against => %w{種類名 備考}
  validates :種類名, presence: true
  validates :種類名, uniqueness: true
  validates :優先さ,   inclusion: {in: proc{Yuusen.pluck(:優先さ)}}, allow_blank: false
  belongs_to :yuusen, foreign_key: :優先さ


  delegate :優先さ, to: :yuusen, allow_nil: true
  def self.import(file)
    # a block that runs through a loop in our CSV data
    CSV.foreach(file.path, headers: true) do |row|
      # creates a user for each row in the CSV file
      Dengonyouken.create! row.to_hash
    end
  end

  def self.to_csv
    attributes = %w{id 種類名 備考 優先さ}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |dengonyouken|
        csv << attributes.map{ |attr| dengonyouken.send(attr) }
      end
    end
  end
  # Naive approach
  def self.rebuild_pg_search_documents
    find_each { |record| record.update_pg_search_document }
  end
end
