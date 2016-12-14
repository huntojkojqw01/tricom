class Shozai < ActiveRecord::Base
  require 'csv'
  self.table_name = :所在マスタ
  self.primary_key = :所在コード

  validates :所在コード, :所在名, presence: true
  validates :所在コード, uniqueness: true

  # has_many :events
  has_many :shainmasters, foreign_key: :所在コード

  alias_attribute :id, :所在コード
  alias_attribute :name, :所在名
  alias_attribute :background_color, :背景色
  alias_attribute :text_color, :文字色

  # a class method import, with file passed through as an argument
  def self.import(file)
    # a block that runs through a loop in our CSV data
    CSV.foreach(file.path, headers: true) do |row|
      # creates a user for each row in the CSV file
      Shozai.create! row.to_hash
    end
  end

  def self.to_csv
    attributes = %w{所在コード 所在名 背景色 文字色}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |shozai|
        csv << attributes.map{ |attr| shozai.send(attr) }
      end
    end
  end

end
