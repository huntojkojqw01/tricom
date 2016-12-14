require 'rails_helper'

RSpec.describe "keihis/show", type: :view do
  before(:each) do
    @keihi = assign(:keihi, Keihi.create!(
      :first_name => "First Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/First Name/)
  end
end
