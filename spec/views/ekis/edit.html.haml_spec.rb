require 'rails_helper'

RSpec.describe "ekis/edit", type: :view do
  before(:each) do
    @eki = assign(:eki, Eki.create!(
      駅コード: "12345", 駅名: "県庁前", 駅名カナ: "ｹﾝﾁｮｳﾏｴ"
    ))
  end

  it "renders the edit eki form" do
    render

    assert_select "form[action=?][method=?]", eki_path(@eki), "post" do

      assert_select "input#eki_駅名カナ[name=?]", "eki[駅名カナ]"

      assert_select "input#eki_駅名[name=?]", "eki[駅名]"
    end
  end
end
