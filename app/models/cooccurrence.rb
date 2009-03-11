class Cooccurrence < ActiveRecord::Base
  include Searchable
  belongs_to :song, :class_name => "Song", :foreign_key => "song_id"
  belongs_to :next_song, :class_name => "Song", :foreign_key => "next_song_id"
end
