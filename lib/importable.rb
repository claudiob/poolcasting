require 'fastercsv'
# require 'ar-extensions'
if ActiveRecord::Base.configurations[RAILS_ENV]["adapter"] == "mysql"
  require 'ar-extensions/adapters/mysql'
  require 'ar-extensions/import/mysql'
end
  
module Importable
  
  class << self
    def included(target)
      target.extend ClassMethods
    end
    
    module ClassMethods
      def fast_import(zipfile, model, columns, options = {})
        table = options[:table] || model.name.pluralize.downcase
        origin = options[:origin] || table
        target = "#{Rails.root}/tmp/#{origin}.csv"
        zipfile.extract("#{origin}.csv", target)
        if ActiveRecord::Base.configurations[RAILS_ENV]["adapter"] == "mysql"
          ### Requires MySQL (fast, about 5 minutes)
          query = <<END_SQL.gsub(/\s+/, " ").strip
          LOAD DATA LOCAL INFILE '#{target}' INTO TABLE #{table}
          FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
          (#{columns.join(', ')})
END_SQL
          ActiveRecord::Base.connection.execute query
        else
          ### Portable (very slow, about one hour)      
          data = FasterCSV.read(target)
          model.import columns, data, {:validate => false}        
        end
        File.delete(target)
      end
    end
  end
end

class ActiveRecord::Migration
  include Importable
end