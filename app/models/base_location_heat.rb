class BaseLocationHeat
  def initialize(params={})
    @campaign_id = params[:campaign_id]
    @start_date = Date.parse(params[:start_date])
    @end_date = Date.parse(params[:end_date])
    @user = params[:user]
  end

  def data
    locations_by_date.map do |d, models|
      LocationHeatDaily.new({date: d, campaigns: models}).as_json
    end
  end

end