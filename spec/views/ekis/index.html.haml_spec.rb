require 'rails_helper'
def current_user
  return User.first
end
RSpec.describe "ekis/index", type: :view do
  fixtures :ekis,:users
  before(:each) do
    @eki=Eki.new
    assign(:ekis, Eki.all)
  end
 
  it "renders a list of ekis" do
    render    
    assert_select "tr", count: Eki.count+1
    assert_select "tr>td", :text => ekis(:eki_0).駅コード, :count => 1
    assert_select "tr>td", :text => "ｹﾝﾁｮｳﾏｴ", :count => 1

    assert_select "button#new_eki", :text => "新規", :count=> 1
    assert_select "button#edit_eki", :text => "編集", :count=> 1
    assert_select "button#destroy_eki", :text => "削除", :count=> 1

    assert_select "#eki-new-modal", :count=> 1
    assert_select "#eki-edit-modal", :count=> 1
  end
end
