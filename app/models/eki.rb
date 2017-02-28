class Eki < ActiveRecord::Base
  include PgSearch
  multisearchable :against => [:駅コード, :駅名, :駅名カナ]

  self.table_name = :駅マスタ
  self.primary_key = :駅コード


  validates :駅コード, :駅名, presence: true
  validates :駅コード, uniqueness: true

  alias_attribute :id, :駅コード
  alias_attribute :name, :駅名

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      Eki.create! row.to_hash
    end
  end

  def self.to_csv
    attributes = %w{駅コード 駅名 駅名カナ 選択回数}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |eki|
        csv << attributes.map{ |attr| eki.send(attr) }
      end
    end
  end

  # Naive approach
  def self.rebuild_pg_search_documents
    find_each { |record| record.update_pg_search_document }
  end

end
