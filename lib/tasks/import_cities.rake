require 'rest-client'
namespace :dashboard do
  task import_cities: :environment do
    auth = RestClient.post "http://demandapi.bidstalk.com/advertiser/auth", { api_key: '29e8021bc18f9c9bd5845e492f9d3307', email: 'it@yoose.com' }.to_json, :content_type => :json, :accept => :json
    auth = JSON.parse(auth)
    token = auth['data']['token']

    countries = RestClient.post "http://demandapi.bidstalk.com/advertiser/meta/countries", { token: token }.to_json, :content_type => :json, :accept => :json
    countries = JSON.parse(countries)

    states = RestClient.post "http://demandapi.bidstalk.com/advertiser/meta/states", { token: token }.to_json, :content_type => :json, :accept => :json
    states = JSON.parse(states)

    system_countries = Country.all
    system_countries.each do |sys_country|
      countries['countries'].select { |c| c['alpha2'] == sys_country[1] }.each do |country|
        states['states'].select { |s| s['country_id'] == country['id'] }.each do |state|
          Density.find_or_create_by(country_code: sys_country[1].downcase, city_name: state['name'])
        end
      end
    end
  end
end