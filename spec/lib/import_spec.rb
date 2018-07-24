require 'rails_helper'
include Import

RSpec.describe Import, type: :lib do
  describe "import normal" do
    it " use string table_name then success" do
      puts import_from_csv("Eki", File.open("spec/lib/import.csv"), %w(駅コード 駅名 駅名カナ), %w(駅コード))
      expect(Eki.count).to eq 6
    end

    it " use class table_name then success" do
      puts import_from_csv(Eki, File.open("spec/lib/import.csv"))
      expect(Eki.count).to eq 6
    end

  end

  describe "import with wrong keys" do
    it "then failed" do
      puts import_from_csv("Eki", File.open("spec/lib/import.csv"), %w(駅コード 駅名 駅名カナ), %w(駅コード2))
      expect(Eki.count).to eq 0
    end
  end
end