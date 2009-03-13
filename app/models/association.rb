class Association < ActiveRecord::Base
  include Searchable
  belongs_to :cooccurrence
  belongs_to :parameter
  delegate   :predecessor, :to => :cooccurrence
  delegate   :successor,   :to => :cooccurrence

  def degree
    0.5*self.song_to_song + 0.3*self.song_to_artist + 0.2*self.artist_to_artist
  end

end

