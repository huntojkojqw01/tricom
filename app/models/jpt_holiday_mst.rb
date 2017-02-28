class JptHolidayMst < ActiveRecord::Base
  include PgSearch
  multisearchable :against => %w{event_date title description}
  def self.import(file)
    # a block that runs through a loop in our CSV data
    CSV.foreach(file.path, headers: true) do |row|
      # creates a user for each row in the CSV file
      JptHolidayMst.create! row.to_hash
    end
  end
  def self.to_csv
    attributes = %w{event_date title description}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |jpt_holiday|
        csv << attributes.map{ |attr| jpt_holiday.send(attr) }
      end
    end
  end
  # Naive approach
  def self.rebuild_pg_search_documents
    find_each { |record| record.update_pg_search_document }
  end
end
