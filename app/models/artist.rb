class Artist < ActiveRecord::Base
  include Searchable
  has_many :songs
end
