class Path < ApplicationRecord
  self.table_name = :paths

  validates :path_url, presence: true


  def self.import(file)

    # a block that runs through a loop in our CSV data
    CSV.foreach(file.path, headers: true) do |row|
      # creates a user for each row in the CSV file
      Path.create! row.to_hash
    end
  end

  def self.to_csv
    attributes = %w{title_jp title_en model_name_field path_url}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |path|
        csv << attributes.map{ |attr| path.send(attr) }
      end
    end
  end
end
