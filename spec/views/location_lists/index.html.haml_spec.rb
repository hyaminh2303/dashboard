require 'rails_helper'

RSpec.describe "location_lists/index", :type => :view do
  before(:each) do
    assign(:location_lists, [
      LocationList.create!(),
      LocationList.create!()
    ])
  end

  it "renders a list of location_lists" do
    render
  end
end
