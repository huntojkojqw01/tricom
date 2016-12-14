class Yakushokumaster < ActiveRecord::Base
  self.table_name = :役職マスタ
  self.primary_key = :役職コード

  validates :役職コード, :役職名, presence: true
  validates :役職コード, uniqueness: true

  has_many :shainmasters, foreign_key: :役職コード

  alias_attribute :id, :役職コード

  def self.import(file)
    # a block that runs through a loop in our CSV data
    CSV.foreach(file.path, headers: true) do |row|
      # creates a user for each row in the CSV file
      Yakushokumaster.create! row.to_hash
    end
  end

  def self.to_csv
    attributes = %w{役職コード 役職名}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |yakushokumaster|
        csv << attributes.map{ |attr| yakushokumaster.send(attr) }
      end
    end
  end
end
