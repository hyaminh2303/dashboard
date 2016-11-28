require 'rails_helper'

RSpec.describe "publishers/show", :type => :view do
  before(:each) do
    @publisher = assign(:publisher, Publisher.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
