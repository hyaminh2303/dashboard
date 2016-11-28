require 'rails_helper'

RSpec.describe "location_lists/edit", :type => :view do
  before(:each) do
    @location_list = assign(:location_list, LocationList.create!())
  end

  it "renders the edit location_list form" do
    render

    assert_select "form[action=?][method=?]", location_list_path(@location_list), "post" do
    end
  end
end
