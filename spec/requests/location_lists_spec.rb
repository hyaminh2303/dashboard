require 'rails_helper'

RSpec.describe "LocationLists", :type => :request do
  describe "GET /location_lists" do
    it "works! (now write some real specs)" do
      get location_lists_path
      expect(response).to have_http_status(200)
    end
  end
end
