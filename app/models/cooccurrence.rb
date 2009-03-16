class Cooccurrence < ActiveRecord::Base
  belongs_to :first_song, :class_name => "Song", :foreign_key => "song_id"
  belongs_to :next_song,  :class_name => "Song", :foreign_key => "next_song_id"
  has_many :associations

  def self.generate_associations
    p = Parameter.active
    # When Rails bug #2227 is fixed in Rails 2.3, change the next line for:
    # Cooccurrence.find_each(:include => [:first_song, :next_song]) do |c|
    Cooccurrence.find_each do |c|
      Association.create(:cooccurrence => c, :parameter => p)
    end
  end

  def counts_as_first_song
    fields = ["sum(d1)", "sum(d2)", "sum(d3)"]
    instances = Cooccurrence.first(:select => fields.join(" ,"), 
      :conditions => ["song_id = ?", self.song_id])
    instances.attributes.values_at(*fields).collect {|x| x.to_i }
  end
  
  def counts_as_next_song
    fields = ["sum(d1)", "sum(d2)", "sum(d3)"]
    instances = Cooccurrence.first(:select => fields.join(" ,"), 
      :conditions => ["next_song_id = ?", self.next_song_id])
    instances.attributes.values_at(*fields).collect {|x| x.to_i }
  end

  def counts_as_both_artists
    fields = ["sum(d1)", "sum(d2)", "sum(d3)"]
    instances = Cooccurrence.first(:select => fields.join(" ,"), 
      :joins => "JOIN songs s1 ON s1.id = song_id JOIN songs s2 ON s2.id = next_song_id",
      :conditions => "s1.artist_id = #{self.first_song.artist_id} AND s2.artist_id = #{self.next_song.artist_id}")
    instances.attributes.values_at(*fields).collect {|x| x.to_i }
  end

  def counts_as_first_artist
    fields = ["sum(d1)", "sum(d2)", "sum(d3)"]
    instances = Cooccurrence.first(:select => fields.join(" ,"), 
      :joins => "JOIN songs s1 ON s1.id = song_id",
      :conditions => "s1.artist_id = #{self.first_song.artist_id}")
    instances.attributes.values_at(*fields).collect {|x| x.to_i }
  end

  def counts_as_next_artist
    fields = ["sum(d1)", "sum(d2)", "sum(d3)"]
    instances = Cooccurrence.first(:select => fields.join(" ,"), 
      :joins => "JOIN songs s2 ON s2.id = next_song_id",
      :conditions => "s2.artist_id = #{self.next_song.artist_id}")
    instances.attributes.values_at(*fields).collect {|x| x.to_i }
  end

  def counts_as_next_artist_for_song
    fields = ["sum(d1)", "sum(d2)", "sum(d3)"]
    instances = Cooccurrence.first(:select => fields.join(" ,"), 
    :joins => "JOIN songs s2 ON s2.id = next_song_id",
      :conditions => ["song_id = ? AND next_song_id <> ? AND s2.artist_id = ?", 
          self.song_id, self.next_song_id, self.next_song.artist_id])
    instances.attributes.values_at(*fields).collect {|x| x.to_i }
  end
      
  def cumulative_counts
    a = self.d1, self.d2, self.d3
    b = self.counts_as_first_song
    c = self.counts_as_next_song
    d = self.counts_as_both_artists.zip(a).collect{|x| x[0] - x[1]} 
    if d == [0, 0, 0] # no more artists co-occurrences
      e = f = g = d
    else
      e = self.counts_as_first_artist
      f = self.counts_as_next_artist
      g = self.counts_as_next_artist_for_song
    end
    {:song_to_song => {:both => a, :first => b, :next => c}, 
     :song_to_artist => {:both => g, :first => b, :next => f},
     :artist_to_artist => {:both => d, :first => e, :next => f}}
  end
end
