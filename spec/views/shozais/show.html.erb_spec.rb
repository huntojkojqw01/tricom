require 'rails_helper'

RSpec.describe "shozais/show", type: :view do
  before(:each) do
    @shozai = assign(:shozai, Shozai.create!(
      :shozai_code => "Shozai Code",
      :shozai_name => "Shozai Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Shozai Code/)
    expect(rendered).to match(/Shozai Name/)
  end
end
