class Parameter < ActiveRecord::Base
  has_many :associations
  
  def self.active
    Parameter.last
  end
end
