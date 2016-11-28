require 'rails_helper'

RSpec.describe "location_lists/show", :type => :view do
  before(:each) do
    @location_list = assign(:location_list, LocationList.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
