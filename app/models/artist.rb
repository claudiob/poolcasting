class Artist < ActiveRecord::Base
  include Searchable
  has_many :cooccurrences,  :as => :predecessor
  has_many :cooccurrences, :as => :successor

  has_many :songs
end
