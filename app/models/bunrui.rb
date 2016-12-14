class Bunrui < ActiveRecord::Base
  self.table_name = :分類マスタ
  self.primary_key = :分類コード

  validates :分類コード, uniqueness: true
  validates :分類コード, :分類名, presence: true

  has_one :jobmaster, foreign_key: :分類コード
  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      Bunrui.create! row.to_hash
    end
  end

  def self.to_csv
    attributes = %w{分類コード 分類名}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |user|
        csv << attributes.map{ |attr| user.send(attr) }
      end
    end
  end
end
