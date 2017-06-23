require 'rails_helper'

RSpec.describe "ekis/new", type: :view do
  before(:each) do
    assign(:eki, Eki.new(
      駅コード: "12345", 駅名: "県庁前", 駅名カナ: "ｹﾝﾁｮｳﾏｴ"
    ))
  end

  it "renders new eki form" do
    render

    assert_select "form[action=?][method=?]", ekis_path, "post" do

      assert_select "input#eki_駅コード[name=?]", "eki[駅コード]"

      assert_select "input#eki_駅名[name=?]", "eki[駅名]"
      assert_select "input#eki_駅名カナ[name=?]", "eki[駅名カナ]"
    end
  end
end
