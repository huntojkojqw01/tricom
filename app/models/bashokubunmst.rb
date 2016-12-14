class Bashokubunmst < ActiveRecord::Base
  self.table_name = :場所区分マスタ
  self.primary_key = :場所区分コード

  validates :場所区分コード, :場所区分名, presence: true
  validates :場所区分コード, uniqueness: true

  has_one :bashomaster, foreign_key: :場所区分コード

  alias_attribute :code, :場所コード
  alias_attribute :name, :場所名
  # a class method import, with file passed through as an argument
  def self.import(file)
    # a block that runs through a loop in our CSV data
    CSV.foreach(file.path, headers: true) do |row|
      # creates a user for each row in the CSV file
      Bashokubunmst.create! row.to_hash
    end
  end

  def self.to_csv
    attributes = %w{場所区分コード 場所区分名}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |bashokubunmst|
        csv << attributes.map{ |attr| bashokubunmst.send(attr) }
      end
    end
  end
end
