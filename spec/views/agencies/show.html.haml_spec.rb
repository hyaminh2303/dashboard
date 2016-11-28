require 'rails_helper'

RSpec.describe "agencies/show", :type => :view do
  before(:each) do
    @agency = assign(:agency, Agency.create!(
      :name => "Name",
      :country_code => "Country Code",
      :email => "Email"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Country Code/)
    expect(rendered).to match(/Email/)
  end
end
