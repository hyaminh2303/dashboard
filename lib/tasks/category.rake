require 'csv'
namespace :category do
  desc 'Generate Category data'
  task :import => :environment do
    import_csv Category

  end

  def import_csv(model, file_name=nil)
    puts model.name
    file_name = model.name.downcase if file_name.nil?
    ActiveRecord::Base.connection.execute("TRUNCATE #{file_name.pluralize}")
    current_dir = File.dirname(__FILE__)
    source_file = current_dir + "/csv/#{file_name}.csv"
    CSV.foreach(source_file, headers: true) do |row|
      hash_row = row.to_hash
      m = model.new(hash_row)
      m.id = hash_row['id']
      unless m.save!
        puts "Error at #{model.name}: #{source_file}"
      end
      puts m.inspect
    end
    puts 'Finished'
  end
end
