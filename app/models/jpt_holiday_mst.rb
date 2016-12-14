class JptHolidayMst < ActiveRecord::Base

  def self.import(file)
    # a block that runs through a loop in our CSV data
    CSV.foreach(file.path, headers: true) do |row|
      # creates a user for each row in the CSV file
      JptHolidayMst.create! row.to_hash
    end
  end
  def self.to_csv
    attributes = %w{id event_date title description}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |jpt_holiday|
        csv << attributes.map{ |attr| jpt_holiday.send(attr) }
      end
    end
  end
end
