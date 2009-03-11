module Importable
  
  class << self
    def included(target)
      target.extend ClassMethods
    end
    
    module ClassMethods
      def fast_import(zipfile, model, columns)
        table  = model.name.pluralize.downcase
        origin = "#{table}.csv"
        if ActiveRecord::Base.configurations[RAILS_ENV]["adapter"] == "mysql"
          ### Requires MySQL (very fast, about one minute)
          target = "#{Rails.root}/tmp/#{origin}"
          zipfile.extract(origin, "#{target}")
          ActiveRecord::Base.connection.execute <<END_SQL.gsub(/\s+/, " ").strip
          LOAD DATA LOCAL INFILE '#{target}' INTO TABLE #{table}
          FIELDS TERMINATED BY ',' ENCLOSED BY '"'
          (#{columns.join(', ')})
END_SQL
          File.delete("#{target}")
        else
          ### Portable (very slow, about one hour)      
          data = FasterCSV.parse(zipfile.read(origin))
          model.import columns, data, {:validate => false}        
        end
      end
    end
  end
end

class ActiveRecord::Migration
  include Importable
end