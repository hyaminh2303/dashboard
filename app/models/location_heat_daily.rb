class LocationHeatDaily
  include ActiveModel::Model

  attr_accessor :year, :month, :day, :types

  def initialize(params = {})
    date = params[:date]
    @year = date.year
    @month = date.month
    @day = date.day
    @types = {
       'impression' =>[], 'click' =>[]
    }
    import_data params[:campaigns]
  end

  private

  def import_data(campaigns)
    campaigns.each do |m|
      @types['impression'] << [m.latitude.to_f, m.longitude.to_f, m.views] if m.views.present?
      @types['click'] << [m.latitude.to_f, m.longitude.to_f, m.clicks] if m.views.present?
    end
  end
end