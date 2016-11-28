require 'rails_helper'

RSpec.describe "publishers/new", :type => :view do
  before(:each) do
    assign(:publisher, Publisher.new())
  end

  it "renders new publisher form" do
    render

    assert_select "form[action=?][method=?]", publishers_path, "post" do
    end
  end
end
