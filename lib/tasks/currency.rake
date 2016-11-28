namespace :currency do
  desc 'Generate default currency list'
  task :import => :environment do
    %w(USD EUR AUD SGD GBP NZD).each do |i|
      currency = Currency.new({name: i, code: i})
      if currency.save
        puts currency.inspect
      end
    end
  end
end
