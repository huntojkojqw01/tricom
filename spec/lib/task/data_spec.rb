require 'rake'
require 'rails_helper'
Jpt::Application.load_tasks
RSpec.describe Rake::Task, type: :task do
  describe "Remove old data" do
    before do |variable|
      Setting.create(id: 81000, 社員番号: 81000, turning_data: true)
      Setting.create(id: 81001, 社員番号: 81001, turning_data: false)
      Dengon.create(
        from1: "テスト",
        from2: "テスト名前",
        日付: 2.years.ago,
        入力者: "99091",
        用件: "6",
        回答: "9",
        伝言内容: "古谷作成、合林専務へ",
        確認: true,
        送信: false,
        社員番号: "81000"
        )
      Dengon.create(
        from1: "テスト",
        from2: "テスト名前",
        日付: 2.years.ago,
        入力者: "99091",
        用件: "6",
        回答: "9",
        伝言内容: "古谷作成、合林専務へ",
        確認: true,
        送信: false,
        社員番号: "81001"
        )
      Dengon.create(
        from1: "テスト",
        from2: "テスト名前",
        日付: 1.months.from_now,
        入力者: "99091",
        用件: "6",
        回答: "9",
        伝言内容: "古谷作成、合林専務へ",
        確認: true,
        送信: false,
        社員番号: "81000"
        )
      Rake::Task['data:remove'].invoke
    end
    it "remove all" do   
      expect(Dengon.count).to eq(2)
    end
  end

end
