class GeosController < ApplicationController
  def index
  end

  def get_city
    Geocoder.search("10.762622,106.660172").first.city
  end
end
