class CountriesController < AuthorizationController
  def index
    @countries = Country.all
    render json: { countries: @countries }
  end
end