require 'rails_helper'

RSpec.describe "publishers/edit", :type => :view do
  before(:each) do
    @publisher = assign(:publisher, Publisher.create!())
  end

  it "renders the edit publisher form" do
    render

    assert_select "form[action=?][method=?]", publisher_path(@publisher), "post" do
    end
  end
end
