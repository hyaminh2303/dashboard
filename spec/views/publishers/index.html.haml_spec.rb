require 'rails_helper'

RSpec.describe "publishers/index", :type => :view do
  before(:each) do
    assign(:publishers, [
      Publisher.create!(),
      Publisher.create!()
    ])
  end

  it "renders a list of publishers" do
    render
  end
end
