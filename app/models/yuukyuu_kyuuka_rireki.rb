class YuukyuuKyuukaRireki < ActiveRecord::Base
  self.table_name = :有給休暇履歴
  self.primary_key = :社員番号, :年月
  include PgSearch
  multisearchable :against => %w{社員番号 年月 }
  validates :年月,:社員番号, presence: true
  belongs_to :shainmaster, foreign_key: :社員番号

  def self.import(file)
    # a block that runs through a loop in our CSV data
    CSV.foreach(file.path, headers: true) do |row|
      # creates a user for each row in the CSV file
      YuukyuuKyuukaRireki.create! row.to_hash
    end
  end

  def self.to_csv
    attributes = %w{社員番号 年月 月初有給残 月末有給残}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |yuukyuu_kyuuka|
        csv << attributes.map{ |attr| yuukyuu_kyuuka.send(attr) }
      end
    end
  end
  # Naive approach
  def self.rebuild_pg_search_documents
    find_each { |record| record.update_pg_search_document }
  end
end
