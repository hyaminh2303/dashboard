require 'rails_helper'

RSpec.describe "agencies/index", :type => :view do
  before(:each) do
    assign(:agencies, [
      Agency.create!(
        :name => "Name",
        :country_code => "Country Code",
        :email => "Email"
      ),
      Agency.create!(
        :name => "Name",
        :country_code => "Country Code",
        :email => "Email"
      )
    ])
  end

  it "renders a list of agencies" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Country Code".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
  end
end
