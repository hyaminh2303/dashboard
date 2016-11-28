require 'rails_helper'

RSpec.describe "agencies/edit", :type => :view do
  before(:each) do
    @agency = assign(:agency, Agency.create!(
      :name => "MyString",
      :country_code => "MyString",
      :email => "MyString"
    ))
  end

  it "renders the edit agency form" do
    render

    assert_select "form[action=?][method=?]", agency_path(@agency), "post" do

      assert_select "input#agency_name[name=?]", "agency[name]"

      assert_select "input#agency_country_code[name=?]", "agency[country_code]"

      assert_select "input#agency_email[name=?]", "agency[email]"
    end
  end
end
