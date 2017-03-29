class Tsushinseigyou < ActiveRecord::Base
  self.table_name = :通信制御マスタ
  # self.primary_key = :社員番号
  # validates :社員番号, presence: true
  # validates :社員番号, uniqueness: true

  belongs_to :shainmaster, foreign_key: :社員番号
  delegate :氏名, to: :shainmaster, prefix: :shain, allow_nil: true
  include PgSearch
  multisearchable :against => %w{shain_氏名 メール}
  # a class method import, with file passed through as an argument
  def self.import(file)
    # a block that runs through a loop in our CSV data
    CSV.foreach(file.path, headers: true) do |row|
      # creates a user for each row in the CSV file
      Tsushinseigyou.create! row.to_hash
    end
  end

  def self.to_csv
    attributes = %w{社員番号 メール 送信許可区分}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |tsushinseigyou|
        csv << attributes.map{ |attr| tsushinseigyou.send(attr) }
      end
    end
  end
  # Naive approach
  def self.rebuild_pg_search_documents
    find_each { |record| record.update_pg_search_document }
  end
end
