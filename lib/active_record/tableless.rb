module ActiveRecord
  # Usage
  # class Foo < ActiveRecord::Tableless
  #   column :name, :string
  #   column :value, :integer
  #
  #   add_columns :first_name, :last_name, type: :string
  #
  #   validates_presence_of :name
  # end
  class Tableless < ActiveRecord::Base

    def self.columns
        @columns ||= []
    end

    def self.column(name, sql_type = nil, default = nil, null = true)
      columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default,
                                                              sql_type.to_s, null)
    end

    def self.add_columns(*args)
      options = args.extract_options!

      raise ArgumentError, 'You need to provide the type of columns' if options[:type].nil?

      args.each do |a|
        column a, options[:type]
      end
    end
  end
end