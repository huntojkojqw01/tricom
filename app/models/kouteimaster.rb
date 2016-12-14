class Kouteimaster < ActiveRecord::Base
  self.table_name = :工程マスタ
  self.primary_keys = :所属コード, :工程コード

  validates :所属コード, :工程コード, :工程名, presence: true
  validates :工程コード, uniqueness: {scope: :所属コード}

  belongs_to :shozokumaster, foreign_key: :所属コード
  has_one :event, foreign_key: [:所属コード, :工程コード]

  alias_attribute :shozokucode, :所属コード
  alias_attribute :code, :工程コード
  alias_attribute :name, :工程名

  delegate :id, to: :shozokumaster, prefix: true, allow_nil: true
  delegate :name, to: :shozokumaster, prefix: true, allow_nil: true

  def self.import(file)

    # a block that runs through a loop in our CSV data
    CSV.foreach(file.path, headers: true) do |row|
      # creates a user for each row in the CSV file
      Kouteimaster.create! row.to_hash
    end
  end

  def self.to_csv
    attributes = %w{所属コード 工程コード 工程名}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |kouteimaster|
        csv << attributes.map{ |attr| kouteimaster.send(attr) }
      end
    end
  end
end
