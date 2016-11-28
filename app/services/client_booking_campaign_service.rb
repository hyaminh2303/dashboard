class ClientBookingCampaignService
  class << self
    def calculate_impression_assessment(params)
      banner_size = params[:banner_size] || []
      country_code = params[:country_code]
      city_name = params[:city_name]
      locations = (params[:locations] || []).map { |l| JSON.parse(l) }
      total_impression_assessment = 0
      banner_size.each do |size|
        total_impression_assessment += get_impression_assessment(size, country_code, city_name, locations)
      end
      total_impression_assessment
    end

    def get_impression_assessment(size, country_code, city_name, locations)
      if city_name
        get_impression_assessment_city(size, country_code, city_name, locations)
      else
        get_impression_assessment_country(size, country_code)
      end
    end

    def get_impression_assessment_country(size, country_code)
      daily_est_imp = DailyEstImp.find_by(banner_size_id: size, country_code: country_code)
      daily_est_imp.try(:impression).to_i
    end

    def get_impression_assessment_city(size, country_code, city_name, locations)
      country_impression = get_impression_assessment_country(size, country_code)
      country_population = CountryCost.find_by(country_code: country_code).try(:population)
      city = Density.find_by(country_code: country_code, city_name: city_name)
      if city.present? && country_population.present? && country_impression.present?
        if locations.present?
          locations_population = 0
          locations.select{ |l| !l['_destroy']}.each do |location|
            locations_population += city.density * Math::PI * location['radius'].to_i * location['radius'].to_i
          end
          (locations_population * country_impression)/country_population
        else
          (city.population.to_i * country_impression)/country_population
        end
      else
        0
      end
    end
  end
end