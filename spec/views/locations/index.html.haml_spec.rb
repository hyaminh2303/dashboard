require 'rails_helper'

RSpec.describe "locations/index", :type => :view do
  before(:each) do
    assign(:location, [
      Location.create!(),
      Location.create!()
    ])
  end

  it "renders a list of locations" do
    render
  end
end
