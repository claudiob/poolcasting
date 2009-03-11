# This module will make search available to different models (song, artist, ..)
# I just need to find out how to extend ActiveRecord
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