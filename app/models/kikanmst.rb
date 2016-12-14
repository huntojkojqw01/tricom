class Kikanmst < ActiveRecord::Base
  self.table_name = :機関マスタ
  self.primary_key = :機関コード

  validates :機関コード, :機関名, presence: true
  validates :機関コード, uniqueness: true

  alias_attribute :id, :機関コード
  alias_attribute :name, :機関名
  alias_attribute :note, :備考

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      Kikanmst.create! row.to_hash
    end
  end

  def self.to_csv
    attributes = %w{機関コード 機関名 備考}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |kikanmst|
        csv << attributes.map{ |attr| kikanmst.send(attr) }
      end
    end
  end
end
