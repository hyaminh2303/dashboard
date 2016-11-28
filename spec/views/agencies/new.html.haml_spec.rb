require 'rails_helper'

RSpec.describe "agencies/new", :type => :view do
  before(:each) do
    assign(:agency, Agency.new(
      :name => "MyString",
      :country_code => "MyString",
      :email => "MyString"
    ))
  end

  it "renders new agency form" do
    render

    assert_select "form[action=?][method=?]", agencies_path, "post" do

      assert_select "input#agency_name[name=?]", "agency[name]"

      assert_select "input#agency_country_code[name=?]", "agency[country_code]"

      assert_select "input#agency_email[name=?]", "agency[email]"
    end
  end
end
