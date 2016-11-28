require 'rails_helper'

RSpec.describe "platforms/show", :type => :view do
  before(:each) do
    @platform = assign(:platform, Platform.create!(
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end
