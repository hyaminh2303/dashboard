require 'rails_helper'

RSpec.describe "currencies/new", :type => :view do
  before(:each) do
    assign(:currency, Currency.new(
      :name => "MyString",
      :code => "MyString"
    ))
  end

  it "renders new currency form" do
    render

    assert_select "form[action=?][method=?]", currencies_path, "post" do

      assert_select "input#currency_name[name=?]", "currency[name]"

      assert_select "input#currency_code[name=?]", "currency[code]"
    end
  end
end
