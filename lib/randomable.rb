module Randomable
  
  class << self
    def included(target)
      target.extend ClassMethods
    end
    
    module ClassMethods
      def random()
        self.first(:offset => rand(self.count-1))
      end
    end
  end
end

class ActiveRecord::Base
  include Randomable
end