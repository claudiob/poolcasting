class Song < ActiveRecord::Base
  include Searchable
  
  belongs_to :artist
  belongs_to :genre
  has_many :cooccurrences, :class_name => "cooccurrence" #, :foreign_key => "song_id"
#  has_many :postoccurrences, :class_name => "cooccurrence", :foreign_key => "next_song_id"

end
