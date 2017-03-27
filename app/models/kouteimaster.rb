class Kouteimaster < ActiveRecord::Base
  self.table_name = :工程マスタ
  self.primary_keys = :工程コード, :所属コード
  include PgSearch
  multisearchable :against => %w{shozokumaster_name 工程コード 工程名}
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
  # Naive approach
  def self.rebuild_pg_search_documents
    find_each { |record| record.update_pg_search_document }
  end
  # More sophisticated approach
  # def self.rebuild_pg_search_documents
  #   PgSearch::Document.where(:searchable_type => "Kouteimaster").delete_all
  #   connection.execute <<-SQL
  #    INSERT INTO pg_search_documents (searchable_type, searchable_id, content, created_at, updated_at)
  #      SELECT 'Kouteimaster' AS searchable_type,
  #             CAST (工程コード AS integer) AS searchable_id,
  #             (所属マスタ.所属名 || ' ' || 工程コード || ' ' || 工程名) AS content,
  #             now() AS created_at,
  #             now() AS updated_at
  #      FROM 工程マスタ
  #      LEFT JOIN 所属マスタ
  #        ON 所属マスタ.所属コード = 工程マスタ.所属コード
  #   SQL
  # end
end
