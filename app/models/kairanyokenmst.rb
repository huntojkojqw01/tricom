class Kairanyokenmst < ActiveRecord::Base
  self.table_name = :回覧用件マスタ

  belongs_to :yuusen, foreign_key: :優先さ

  validates :名称, presence: true
  delegate :優先さ, to: :yuusen, allow_nil: true
  def self.import(file)
    # a block that runs through a loop in our CSV data
    CSV.foreach(file.path, headers: true) do |row|
      # creates a user for each row in the CSV file
      Kairanyokenmst.create! row.to_hash
    end
  end

  def self.to_csv
    attributes = %w{id 名称 備考 優先さ}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |kairanyoken|
        csv << attributes.map{ |attr| kairanyoken.send(attr) }
      end
    end
  end
end
