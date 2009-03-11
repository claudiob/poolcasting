module Searchable
  
  class << self
    def included(target)
      target.extend ClassMethods
    end
    
    module ClassMethods
      def search(page, options = {})
        paginate :page => page, :per_page  => 20, 
              :conditions => options[:conditions], 
              :include => options[:include],
              :order => options[:order]
      end
    end
  end
end

class ActiveRecord::Base
  include Searchable
end