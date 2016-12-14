class Tsushinseigyou < ActiveRecord::Base
  self.table_name = :通信制御マスタ
  belongs_to :shainmaster, foreign_key: :社員番号
  delegate :氏名, to: :shainmaster, prefix: :shain, allow_nil: true

  # a class method import, with file passed through as an argument
  def self.import(file)
    # a block that runs through a loop in our CSV data
    CSV.foreach(file.path, headers: true) do |row|
      # creates a user for each row in the CSV file
      Tsushinseigyou.create! row.to_hash
    end
  end

  def self.to_csv
    attributes = %w{id 社員番号 メール 送信許可区分}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |tsushinseigyou|
        csv << attributes.map{ |attr| tsushinseigyou.send(attr) }
      end
    end
  end
end
