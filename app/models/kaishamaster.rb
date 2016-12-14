class Kaishamaster < ActiveRecord::Base
  self.table_name = :会社マスタ
  self.primary_key = :会社コード

  validates :会社コード, :会社名, presence: true
  validates :会社コード, uniqueness: true

  has_one :bashomaster, foreign_key: :会社コード
  has_one :jobmaster, foreign_key: :ユーザ番号
  has_many :setsubiyoyaku, dependent: :destroy, foreign_key: :会社コード

  alias_attribute :id, :会社コード
  alias_attribute :name, :会社名
  alias_attribute :note, :備考

# a class method import, with file passed through as an argument
  def self.import(file)
    # a block that runs through a loop in our CSV data
    CSV.foreach(file.path, headers: true) do |row|
      # creates a user for each row in the CSV file
      Kaishamaster.create! row.to_hash
    end
  end

  def to_param
    id.parameterize
  end

  def self.to_csv
    attributes = %w{会社コード 会社名 備考}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |kaishamaster|
        csv << attributes.map{ |attr| kaishamaster.send(attr) }
      end
    end
  end
end
