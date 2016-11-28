require 'rails_helper'

RSpec.describe "location_lists/new", :type => :view do
  before(:each) do
    assign(:location_list, LocationList.new())
  end

  it "renders new location_list form" do
    render

    assert_select "form[action=?][method=?]", location_lists_path, "post" do
    end
  end
end
